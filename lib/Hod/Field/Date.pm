package Hod::Field::Date;

use Apache::Reload;
use Date::Manip;

use vars qw($DEBUG);

$DEBUG = 0;

sub default_field_type { "date NOT NULL" }

sub set_value {           # read something the user entered, 
						  # format it for the database and return that value
	my( $self, $item, $value, $options ) = @_;
	local $DEBUG = $options->{DEBUG} if exists $options->{DEBUG};
	defined $value or ( ( $DEBUG && warn "Date not defined; returning undef" ), return undef );

	if( $value =~ m/^[-0\/]*$/ ) {
		# valid but empty if all 0's and -'s. 
		$DEBUG > 2 && warn "\tEmpty field; returning ''\n";
		return ( "", undef ) if wantarray;
		return "";
	}

	my( $delta, $date );
	# look for "date  +/- delta"
	if( $value =~ /^\s*([\/\.\-\d\\]+|today|now)?\s+([\-\+].*)/ ) { 
		warn "it's a date with a delta: $value date($1) delta($2)" if $DEBUG > 1;

		$delta = $2;
		$date = $1; $date =~ s|\-|/|g; # change - to /

		warn "parsing delta $delta" if $DEBUG > 1;
		$delta = eval { &ParseDateDelta( $delta ) } 
			or ( $DEBUG && warn "error in the delta $delta", 
				return( undef, "Invalid date delta $delta") 
			);

		warn "parsing  date $date" if $DEBUG > 1;

		fix_date( \$date );

		$date = eval { &ParseDate( $date ) }
			or ( $DEBUG && warn "error in the date $date",
				return( undef, "Invalid date $date" )
			);

	} else { # it's just a date
		warn "it's just a date: $value" if $DEBUG > 1;

		if( $value =~ /^[-0\/]*$/ ) {
			warn "empty date - returning ''" if $DEBUG > 1;
			return( "", "" ) if wantarray;
			return( "" );
		} else {
			warn "Not empty: $value" if $DEBUG > 1;
		}
		
		$date = $value; $date =~ s|\-|/|g; # change - to /

		fix_date( \$date );

		$date = eval { &ParseDate( $date ) } 
			or ( ( $DEBUG && warn "error in the date $date" ), 
				return( undef, "Invalid date $value" )
			);
		warn "Parsed date: $date" if $DEBUG > 2;
	}

	if( $delta && $date ) {
		my $err;
		warn "calculating date delta" if $DEBUG > 1;

		warn "   Date: $date\n   Delta: $delta" if $DEBUG > 2;
		my $rc = eval { &DateCalc( $date, $delta, \$err ) };
		if( !$rc ) {
			if( $err == 1 ) {
				$err = "DateCalc reported bad date: $date" ;
			} elsif( $err == 2 ) {
				$err = "DateCalc reported bad delta: $delta" ;
			} elsif( $err == 3 ) {
				$err = "DateCalc reported bad year: $date";
			} else {
				$err = "unknown error: $value";
			}
			warn "error: $err; returning original field value" if $DEBUG;
			return( undef, $err );
		} 
		my $yr = UnixDate( $rc, '%Y' );
		unless( $yr > 1300 ) {
			warn( "Invalid year $yr" ) if $DEBUG;
			return( undef, "Detected invalid year $yr" );
		}
		my $rv = UnixDate( $rc, '%Y%m%d');
		unless( $rv ) {
			warn "Invalid date $value" if $DEBUG;
			return( undef, "Invalid date $value" );
		}
		warn "Returning date: $rv" if $DEBUG > 2;
		return ( $rv, $err ) if wantarray;
		return $rv;
	} elsif( $date ) {  # only a date was given.
		if( $date =~ /^[-0\/]*$/ ) {
			return ( "", "" ) if wantarray;
			return ( "" );
		}
		my $yr = UnixDate( $date, "%Y" );
		return( undef, "Detected invalid year $yr" ) unless $yr > 1300;
		my $rv = UnixDate( $date, "%Y%m%d" );

		warn "Invalid date $value",
			return( undef, "Invalid date $value" ) unless $rv;

		warn "returning the plain date: $rv" if $DEBUG > 1;
		return $rv;
	} else {            # the field was cleared
		warn "the field was cleared" if $DEBUG > 1;
		return "";
	}
}

sub fix_date {
	my $which = shift;

	if( $$which =~ m|^(\d\d?)/(\d\d?)/(\d\d(\d\d)?)$| ) {
		my $t = sprintf( $4 ? "%02d/%02d/%04d" : "%02d/%02d/%02d", $1, $2, $3 );
		warn "translating $$which to $t\n" if $DEBUG;
		$$which = $t;
	}
}

sub html_field {
	my( $class, $name, $value, $attrs, $options, $indent, $debug ) = @_;

	local $DEBUG;
	if( $debug > $DEBUG ) {
		$DEBUG = $debug;
	}

	$value = $class->display_value( $name, $value, $attrs, $options );

	return qq($indent<input type="text" name="$name" value="$value" $attrs>);
}

sub display_value {
	my( $class, $field_name, $value, $attrs, $options ) = @_;

	warn "display_value(): got args: ". Data::Dumper::Dumper( \@_ ) if $DEBUG > 1;

	if( $value =~ m/^[-0\/]*$/ ) {
		# valid but empty if all 0's and -'s. 
		$DEBUG > 2 && warn "\tEmpty field; returning ''\n";
		return ( "", undef ) if wantarray;
		return "";
	}

	my $date;
	if( $value =~ "([-\\d/]+|today|now)? ([\\-+].*)" ) { 
		warn "\tDate + offset: $value\n" if $DEBUG > 2;
		$date = $1; $date =~ s|\-|/|g; # change - to /
		fix_date( \$date );
		$date = &ParseDate( $date );
		$date = eval { &DateCalc( $date, $2 ) } || $date; 
		$value = $date
	} else {
		warn "\tBare date: $value\n" if $DEBUG > 2;
		$value =~ s|\-|/|g; # change - to /
		$date = $value; 
	}
	if( 0+$value ) {
		warn "parsing date $date" if $DEBUG;
		fix_date( \$date );
		my $p = &ParseDate( $date );
		my $t = eval { &UnixDate( $p, "%m-%d-%Y" ) } || 'error!';
		my $y = UnixDate( $p, '%Y' );
		$t = $date if $y < 1300;
		warn "display_value returning $t" if $DEBUG;
		return $t;
	} else {
		warn "display_value returning ''" if $DEBUG;
		return '';
	}
}

1;

=pod=

Copyright 1999-2009 Randy Harmon

Hod is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or   
(at your option) any later version.

Hod is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
GNU General Public License for more details (in the LICENSE file).           
    
You should have received a copy of the GNU General Public License
along with Hod.  If not, see <http://www.gnu.org/licenses/>.

=cut=

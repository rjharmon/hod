package Hod::Field::Pulldown;

use Apache::Reload;
use HTML::Entities;

use vars qw($DEBUG);

$DEBUG = 0;

sub default_field_type { "varchar(255) NOT NULL default ''" }

sub set_value {
	my( $self, $item, $value, $options ) = @_;
	unless( $value ) {
		return( "", undef ) if wantarray;
		return "";
	} else {
		return( $value, undef ) if wantarray;
		return $value;
	}
}

sub html_field {
	my( $class, $name, $value, $attrs, $options, $indent, $debug ) = @_;

	local $DEBUG;
	if( $debug > $DEBUG ) {
		$DEBUG = $debug;
	}
	$attrs and $attrs = " $attrs";

	if( ref($options) eq 'CODE' ) {
		warn "Calling code for $name options" if $DEBUG > 1;
		$options = $options->();
	}

	my $rv = qq($indent<SELECT name="$name"$attrs>\n);
	warn "$name: pulldown" if $DEBUG;
	if( ref( $options ) eq 'HASH' ) {
		foreach my $opt( @{ $options->{_order} || [ sort keys %$options ] } ) {
			next if $opt =~ /^_/;  # skip options with leading underscores
			warn( "\toption: $opt ('". $options->{$opt} . "')" ) if $DEBUG;
			$rv .= qq($indent\t<option value="$opt") . 
				( $value eq $opt ? " SELECTED" : "" ) .
				">$options->{$opt}\n";
		}
	} elsif( ref( $options ) eq 'ARRAY' ) {
		foreach my $opt(  @$options ) {
			warn "\toption: $opt" if $DEBUG;
			my $t = encode_entities( $opt );
			$rv .= qq($indent\t<option value="$t") .
				( lc $value eq lc $opt ? " SELECTED" : "" ) .
				">$t";
		}
	} else {
		die "Pulldown field '$name' requires options defined in the record's options structure";
	}
	$rv .= "$indent</select>";
	return $rv;
}

sub html_display {
	my( $class, $field_name, $value, $attrs, $options ) = @_;
	if( ref($options) eq 'CODE' ) {
		$options = $options->();
	}
	if( ref($options) eq 'HASH' ) {
		return encode_entities( $options->{$value} || $value );
	} else {
		return encode_entities( $value );
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

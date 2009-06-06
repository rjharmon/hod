package Hod::Field::File_Upload;

use Apache::Reload;
use HTTP::File;

use vars qw($DEBUG);

$DEBUG = 0;

sub default_field_type { "varchar(255) NOT NULL" }

sub set_value {
	my( $self, $item, $value, $options ) = @_;

	my $err;
	my $val;

	$options = $options->( $item ) if ref( $options ) eq 'CODE';

	warn( "setting value: $self, $item, $value, $options" ) if $DEBUG;

	unless( -d $options->{repository} ) {
		if( $options->{create} ) {
			mkdir( $options->{repository},0755 ) || die "couldn't create $options->{repository}: $!";
		}
		die( "File upload directory '$options->{repository}' does not exist" ) 
			unless -d $options->{repository};
	} 

	if( $value && ref( $value ) ) {	
		unless( $val = HTTP::File::upload( $value, $options->{repository}, $DEBUG ) ) {
			$err = "Cannot upload file $value\n";
			warn $err if $DEBUG;
			return( undef, $err );
		} else {
			return $val;
		}
	} else {
		return $value;
	}
}

sub html_field {
	my( $class, $name, $value, $attrs, $options, $indent, $debug ) = @_;

	$options = $options->( {} ) if ref( $options ) eq 'CODE';

	local $DEBUG;
	if( $debug > $DEBUG ) {
		$DEBUG = $debug;
	}

	$attrs and $attrs = " $attrs";

	my $rv = "$indent<INPUT type=\"file\" name=\"$name\" value=\"". ( $value ? "" : "none" ). "\"";
	$rv .= "$attrs>";
	warn "File::Upload $name: $rv" if $DEBUG;
	return $rv;
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

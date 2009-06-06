package Hod::Field::Checkbox;

use Apache::Reload;
use HTML::Entities;

use vars qw($DEBUG);

$DEBUG = 0;

sub default_field_type { "char(1) NOT NULL default ''" }

sub html_field {
	my( $class, $name, $value, $attrs, $options, $indent, $debug ) = @_;

	local $DEBUG;
	if( $debug > $DEBUG ) {
		$DEBUG = $debug;
	}

	my $rv = '';

	my $label;
	my $id = '';
	my $for = '';

	my $ind = $indent;

	if( $attrs =~ s/label="([^"]+)"//i ) {
		$label = $1;
		if( $attrs =~ /id="?(\w+)"?/ ) {
			$for = $1;
		} else {			$id = int( rand(5000) + 4999 );
			$for = $id;
		}
		$ind .= "<label for=$for>"
	}

	my( $type, $alt );

	if( $attrs =~ s/type="?(\w+)"?// ) {
		$type = $1;
		if( ! $type =~ /^radio$/i ) {
			die( "unknown field type=... attribute for field $name" );
		} else {
			$type = lc $type;
		}

		if( $attrs =~ s/alt="([^"]+)"//i ) {
			$alt = $1;
		} else {
			die( 'for checkbox field type=radio: alt="..." attribute required for alternative radio button' );
		}
	}

	$attrs and $attrs = " $attrs";

	$attrs =~ s/\s+/ /g;

	$rv .= $ind;

	if( $type eq 'radio' ) {
		$rv .= "<INPUT TYPE=\"RADIO\" name=\"$name\" value=\"x\"";
		$rv .= $id ? " id=\"$id\"" : '';
		$rv .= $value ? " CHECKED" : "";
		$rv .= "$attrs>";
		$rv .= "$label</label>\n$indent<label for=\"alt_$for\">\n";
		$rv .= "<INPUT TYPE=\"RADIO\" name=\"$name\" value=\"\"";
		$rv .= $id ? " id=\"alt_$id\"" : '';
		$rv .= $value ? "" : " CHECKED";
		$rv .= "$attrs>";
		$rv .= "$alt</label>";
	} else {
		$rv .= "<INPUT TYPE=\"CHECKBOX\" value=\"x\" name=\"$name\"";
		$rv .= $id ? " id=\"$id\" " : '';
		$rv .= $value ? " CHECKED" : "";
		$rv .= "$attrs>";
		$rv .= "$label</label>" if $label;
		$rv .= qq{<input type=hidden name="_cb_$name" value=1>};
	}
	warn "checkbox $name: $rv" if $DEBUG;
	return $rv;
}

sub set_value {
	my( $self, $item, $value, $options ) = @_;
	warn "Setting value: '$value'" if $DEBUG;
	if(! $value || $value =~ /^\s+$/ ) {
		warn "(CLEARED)\n" if $DEBUG > 1;
		return( "", undef ) if wantarray;
		return "";
	} else {
		warn "(CHECKED)\n" if $DEBUG > 1;
		return( 'x', undef ) if wantarray;
		return 'x';
	}
}
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

1;
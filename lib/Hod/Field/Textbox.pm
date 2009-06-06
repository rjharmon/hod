package Hod::Field::Textbox;

use Apache::Reload;
use HTML::Entities;

use vars qw($DEBUG);


$DEBUG = 0;

sub default_field_type { "LONGTEXT NOT NULL" }

sub set_value {
	my( $self, $item, $value, $options ) = @_;

	$value =~ s/\cM//g;

	return( $value, undef );
}

sub html_field {
	my( $class, $name, $value, $attrs, $options, $indent ) = @_;

	$attrs and $attrs = " $attrs";

	my $rv = "$indent<TEXTAREA name=\"$name\"$attrs>";
	$rv .= encode_entities( $value );
	$rv .= "</TEXTAREA>";
}

sub html_display {
	my( $class, $field_name, $value, $attrs, $options ) = @_;
	$options ||= {};

	$attrs &&= " $attrs";

	# don't encode the value unless they explicitly forced html to false:
	$value = encode_entities( $value ) if defined $options->{html} && ! $options->{html};

	if( $options->{format} eq 'lines' ) {
		# break text lines into HTML lines:
		$value =~ s/[\n\cM]+$//g;
		$value =~ s/[\n\cM]/<br>\n\n/g;
	} elsif( $options->{format} ne 'none' ) {
		# break text paragraphs into HTML paragraphs
		$value =~ s/[\n\cM]{2}/<\/p>\n\n<p$attrs>/g;  
		$value = "<p$attrs>$value</p>" unless $options->{inline};
		$value =~ s/(\n\n)?<p\Q$attrs\E>(<[^>]+>)<\/p>(\n\n)?/$2/sg;
		$value =~ s/(\n\n)?<p\Q$attrs\E>\s(.*?)<\/p>(\n\n)?/$2/sg;
	}

	return $value;
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

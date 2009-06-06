<%method .title>
HTML Editing Field
</%method>
<%args>
$name
$value => undef
$def
$opts => undef
$attrs => ''
$indent => ''
$DEBUG => 0
</%args>
<%init>
if( $def =~ /^(.*)\.pm$/ ) {
	my $class = "Hod/Field/$def";
	warn "loading class $class" if $DEBUG > 2;
	eval { require $class; 1 } or warn "$class not found";
	$class = "Hod::Field::$1";

	if( UNIVERSAL::can( $class, 'html_field' ) ) {
		warn "sending $name for html_field( $value )" if $DEBUG > 2;
		$value = $class->html_field( $name, $value, $attrs, $opts, $indent, $DEBUG );
		warn "$name html_field(): $value" if $DEBUG > 1;
		return $value;
	} else {
		warn "$name: $class can't html_field(); outputting as a regular field" if $DEBUG > 1;
	}
} elsif( $def ) {
	warn "$name is a regular field" if $DEBUG > 1;
	$value = encode_entities( $value );
	$attrs .= " $opts" unless ref($opts) || !$opts;
	return qq($indent<INPUT type="text" name="$name" value="$value" $attrs>);
} else {
	warn "$name is a hidden field" if $DEBUG > 1;
	$value = encode_entities( $value );
	$attrs .= " $opts" unless ref($opts) || !$opts;
	return qq($indent<INPUT type="hidden" name="$name" value="$value" $attrs>);
}

</%init>


<%method .license>

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

</%method>


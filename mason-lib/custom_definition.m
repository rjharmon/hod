<%args>
$base
$custom_path => undef
$custom => undef
</%args>
<%init>

my( $fields, $options, $defs );
if( UNIVERSAL::isa( $base, 'HTML::Mason::Component' ) ) {
	( $fields, $options, $defs ) = $m->comp( $base );
} else {
	( $fields, $options, $defs ) = @$base;
}


if( $custom ) {
	$custom = $m->fetch_comp( $custom ) if ! ref( $custom );
} elsif( $custom_path ) {
	$custom = $m->fetch_comp( $custom_path );
}

my( $c_fields, $c_options, $c_defs );
if( UNIVERSAL::isa( $custom, 'HTML::Mason::Component' ) ) {
	( $c_fields, $c_options, $c_defs ) = $m->comp( $custom ) 
} elsif( ref( $custom ) eq 'ARRAY' ) {
	( $c_fields, $c_options, $c_defs ) = @$custom;
} else {
	return @$base
}
$c_fields || $c_options || $c_defs or return @$base;

$c_fields ||= {};
$c_options ||= {};
$c_defs ||= {};

foreach( keys %$c_options ) {
	die( "Can't override option '$_'" ) if {
		table => 1,
		primary => 1,
	}->{$_};

	if( $fields->{$_} || $c_fields->{$_} ) {
		# allow complete override of field-specific settings; don't merge 'em
		$options->{$_} = $c_options->{$_};
	} elsif( ref( $c_options->{$_} ) eq 'HASH' ) { 
		$options->{$_} ||= {};
		die( "Session: options for field '$_' can't be overridden with hashref" )
			unless ref( $options->{$_} ) eq 'HASH';

		# merge hashes
		$options->{$_} = { %{ $options->{$_} }, %{ $c_options->{$_} } };
	} elsif( ref( $c_options->{$_} ) eq 'ARRAY' ) {
		$options->{$_} ||= [];
		die( "Session: options for field '$_' can't be overridden with arrayref" )
			unless ref( $options->{$_} ) eq 'ARRAY';

		# override arrays
		$options->{$_} = $c_options->{$_};
	}
}

return (
	{ %$fields, %$c_fields },
	$options,
	{ %$defs, %$c_defs }
);


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

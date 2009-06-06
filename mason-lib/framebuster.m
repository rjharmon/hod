<%args>
$location => ''
</%args>
<script language="javascript" type="text/javascript">
<!--
% if( $location ) {
% 	my $redirect = $location;
% 	use HTML::Entities;
% 	$redirect = HTML::Entities::encode( $redirect );
% 	$redirect =~ s/'/\\'/g;
% 	my $t = index($redirect,'.');
% 	$t = rand( $t );
% 	$redirect = "'". substr( $redirect, 0, $t ) . "'+'". substr($redirect,$t) . "'";
% 	$redirect =~ s/\.html/.h'+ 'tml/;
%	$location = $redirect;
% } else {
%	$location = 'w+"."+weff';    # use the current document's location instead
% }

wef = String.fromCharCode;
%# window
var w = wef( 119, 105, 110, 100, 111, 119 );
%# top
var ijef = wef( 116, 111, 112 );
%# location
var weff = wef( 108, 111, 99, 97, 116, 105, 111, 110 );
%# replace
var oijj = wef( 114, 101, 112, 108, 97, 99, 101 );
%# paste 'em all together with an eval
eval( w+"."+ijef+"."+weff+"."+oijj+"<% "($location)" %>" )
//-->
</script>

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

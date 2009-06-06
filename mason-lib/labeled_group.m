<%args>
$label => undef
$end => undef
$font_size => 12
$background => '#fff'
$left_margin => 3
</%args>
% $background &&= "background:$background;";
% unless( $label || $end ) {
Devlelopment error: labeled_group requires a 'label' or 'end' option.
%	return undef;
% }
% if( $label ) {
<div style="position:relative;margin:0;top:0;left:0;<% $background %>;width:auto">
	<div style="position:absolute;top:0;left:<% int($font_size/2 ) %>px;padding:2px;<% $background || "background:inherit" %>;z-index:100;font-size:<% $font_size %>px"><% $label %>
	</div>
	<div style="width:auto;position:relative;<% $background %>;color:#000;top:<% $font_size %>px;left:0;z-index:99;margin:0;margin-top:3px;margin-bottom:15px;border:1px solid black;padding:3px;padding-top:<% $font_size %>px;padding-left:<% $left_margin %>px;font-size:<% $font_size %>px">
% } 
% if( $end ) {
	</div>
</div>
% }

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

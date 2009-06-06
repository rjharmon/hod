% my $colors = $m->comp('/theme.m:current_colors' );
% my $styles = $m->comp('/theme.m:current_styles' );

<style type="text/css">
<!--
.t_row_even { background:<% $colors->{std_background} %>;<% $styles->{even} %> }
.t_row_odd { background:<% $styles->{alt_background} %>;<% $styles->{odd} %> }
.t_header { background:<% $colors->{header} %>;<% $styles->{header} %> }
.t_row_subtotal { background:<% $colors->{footer} %>;<% $styles->{subtotal} %> }
.t_footer { background:<% $colors->{footer} %>;<% $styles->{footer} %> }
//-->
</style>
% return $styles;

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

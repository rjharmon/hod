<%args>
$id => undef
$count => undef
$initial => undef
$content => undef
$offset => 16

$style => 'border:1px dotted gray;border-right:none;border-top:none;margin:2px;margin-left:4px;padding:2px;padding-left:'. ( $offset - 4 ) .'px;margin-bottom:10px'

$img => undef
$img_style => undef
$img_attrs => undef
$content_style => undef
</%args>

<%shared>
my $included = undef;
my $std_style = undef;
</%shared>
<& /xbrowser.m &>
% unless( $included++ ) {
%	$std_style = $style;
<STYLE type=text/css>
<!--
.foldable { <% $style %> }
//-->
</STYLE>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" src="/foldable.js"></script>
% }
% unless( $id ) {
%		warn( $content ),
%	die( "\$content parameter not valid unless id provided" ) if $content;
% 	$id = {
%		unique => int( rand(500000) + 500000 ),
%		showing => $initial,
%		clickable => 0,
%	};
%	if( $count || ! defined( $count ) ) {
%		$id->{clickable} = 1;
%		if( $img ) {
<div id="img_layer_<% $id->{unique} %>" style="<% $img_style %>">
<img <% $img_attrs %> style="cursor:hand;" onClick="fold_it('img_<% $id->{unique} %>', 'layer_<% $id->{unique} %>', 'single');" name="img_<% $id->{unique} %>" id="img_<% $id->{unique} %>" src="<% $img %>" border=0>
</div>
%		} else {
<img style="cursor:hand" onClick="fold_it('img_<% $id->{unique} %>', 'layer_<% $id->{unique} %>', false);" name="img_<% $id->{unique} %>" id="img_<% $id->{unique} %>" src="/i/<%  (!$initial )? "un" : "" %>fold.gif" width=12 height=12 border=0>&nbsp;\
%		}
%	} else {
<img src="/i/fold.gif" width=12 height=12 border=0 alt="No items to view">&nbsp;\
%	}
%	return $id;
% } else {
% 	die( "Required: \$content, if id provided") unless $id;
<div id="layer_<% $id->{unique} %>" style="display:<% $id->{showing} ? 'block' :'none' %>;<% $content_style %>\
% if( $style eq $std_style ) {
" class=foldable \
% } else {
<% $style %>" \
% }
><% $content %></div>
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

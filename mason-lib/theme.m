<%method .doc_synopsis>
<b>Set color theme for store</b>: Sets colors used for various elements in the
store systems.
</%method>

<%method .doc>
<h2>Usage</h2>

<p>To define a color theme for your site, create a file <tt>/theme.m</tt> which
contains the following information.  The default colors are shown.  You may 
override any or all of the defaults. </p>

<pre><% <<EOD
<\%method colors>
<\%init>
return {
  background => '#ffffff',
  alt_background => '#cccccc',
  box_border => '#000000',
  box_title_bar => '#000000',
  box_title_text => '#ffffff',
  box_text => '#000000'
};
</\%init>
</\%method>
EOD
 |h %></pre>

<p>The available color settings are used as follows:</p>

<ul>
	<li><p><b>background</b>: The normal background color for the website.  For
	alternating bars in a table, this is used for the odd-numbered rows.</p>

	<li><p><b>alt_background</b>: The alternative background color for the website.
	This is used for boxes that are displayed "on top" of the normal background color,
	and is also used for even-numbered bars in an alternating-bars table.</p>

	<li><p><b>box_border</b>: The color used for the border of boxes and tables
	used by the web store.</p>

	<li><p><b>box_title_bar</b>: The color used for the background of title bars and
	table headers.</p>

	<li><p><b>box_title_text</b>: The color of text in box titles and table headers.</p>

	<li><p><b>box_text</b>: The color of text displayed on top of the background and
	alt_background colors in boxes and tables.  Typically the same as or similar to
	the site's normal text color for the content area.</p>
</ul>

<h2>Retrieving Settings</h2>

<p>If you are writing a module that wishes to use the site's color theme,
you may retrieve the values listed above as a hash reference, using this
module's <tt>current_colors</tt> method.  For example:</p>

<pre><% <<EOD
\% my \$theme = \$m->comp("/theme.m:current_colors");
<font color="<\% \$theme->{box_text} %\>">My box text</font>
EOD
 |h %></pre>

<p>You may also wish to use the <tt>current_styles</tt> method.  The settings 
are returned in the same format as <tt>current_colors</tt>, and include the 
following styles:</p>

<ul>
	<li><p><b>odd</b>: The style used for odd-numbered rows in tables supporting
	the site's theme.  No default (same as normal text).</p>

	<li><p><b>even</b>: The style used for even-numbered rows in tables. The
	default includes use of the alt_background color for better readability, 
	along with a matching top and bottom border, especially for readability when
	the page is printed without the background colors.</p>

	<li><p><b>header</b>: The style used for the header row in tables.  The default
	includes a thick bottom border.</p>

	<li><p><b>subtotal</b>: The style used for subtotals, such as in display of
	an order for review by the customer.</p>

</ul>

</%method>

<%method colors>
<%init>
return {};
</%init>
</%method>

<%def .default_colors>
<%init>
my $styles = eval{ $m->comp('/store/custom_options.m') } || {};
$styles = $styles->{style};
my $header_color = $styles->{header_color} || '#000000';
return {
  std_background => $styles->{odd_color} || '#ffffff',
  std_text => '#000000',
  alt_text => '#000000',
  alt_background => $styles->{even_color} || '#cccccc',
  border => '#000000',
  header => $header_color,
  footer => $styles->{footer_color} || '#000000',
  box_title_text => '#ffffff', # xxx not used; see below for setting of default title color
};
</%init>
</%def>

<%method current_colors>
% my $defaults = $m->comp(".default_colors");
% my $colors = $m->comp("SELF:colors");
% unless( ref( $colors ) eq 'HASH' ) {
<h2>Development Error</h2>
<p>method 'colors' must return a hash reference.</p>
<p>See <a href="/doc.html?module=/theme.m">my documentation</a> for more information.</p>
% }
%
% # make the default title color the exact reverse of the actual header color.
% # this has no effect if the site's theme has defined a specific box_title_text color.
%
% my $header_color = $colors->{header} || $defaults->{header};
% my $default_title_text = '#'. join( '', 
%	map {                              
% 		my $t = oct("0x79") - hex( $_ ); 
%		warn "$_ => ". hex( $_ ). "; $t\n";
%		sprintf( "%02x", $t );
%	} 
%	$header_color =~ /\#?(.{2})(.{2})(.{2})/  # split out hex digits
% );
% $colors->{box_title_text} ||= $default_title_text;
%
% return { %$defaults, %$colors };
</%method>

<%def .default_styles>
<%init>
my $styles = eval{ $m->comp('/store/custom_options.m') } || {};
$styles = $styles->{style};
return {
	even => $styles->{even} || "padding-top:0;padding-bottom:0;border-top:1px solid %alt_background%;border-bottom:1px solid %alt_background%;",
	header => $styles->{header} || "border:0;border-bottom:1px solid black;",
	subtotal => $styles->{subtotal} || "border-top:1px solid black",
};
</%init>
</%def>

<%method styles>
<%init>
return {};
</%init>
</%method>

<%method current_styles>
<%init>
my $color = $m->comp('theme.m:current_colors');
my $style = $m->comp('.default_styles');
my $custom_style = $m->comp("SELF:styles");
foreach ( keys %{ { map { $_ => 1 } keys %$custom_style, keys %$style } } ) {
	my $custom = $custom_style->{$_};
	if( $custom =~ /^\+/ ) {
		$custom =~ s/^\+//;
		$style->{$_} .= $custom;
	} elsif( $custom ) {
		$style->{$_} = $custom;
	}
}
foreach( keys %$style ) {
	$style->{$_} =~ s/\%([a-zA-Z_]+)\%/ $style->{$1} || $color->{$1} /eg;
}
return $style;
</%init>
</%method>

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

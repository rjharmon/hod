<%method .title>
Color choices for items in the Store Catalog
</%method>
<%method .doc_synopsis>
Fetch or display a drop-down of color choices for a given product.
</%method>
<%method .doc>
<h2>Usage</h2>
<p>To display a drop-down list of color choices for a product, use
a call such as:</p>

<pre><% <<EOD
<\& /store/shop/color_choices.m, sku => 'PROD-1' &\>

<\& /store/shop/color_choices.m, item => \$item &\>
EOD
 |h %></pre>

<p>In the first example, the item has not been fetched from the database, 
so the sku number is provided.  This is useful for custom catalog pages
highlighting specific products. </p>

<p>In the second example, the items has already been fetched from the 
database, perhaps as part of a query for multiple items.  By passing 
the item directly, you can save the overhead of individually fetching 
multiple database rows for individual sku's.
</p>

<p>Pricing differentials (with + or -) are displayed, unless the base price of the product 
is zero.  In this case, the "differentials" entered in the product database
are assumed to be the full price of each size, and that price is displayed 
without the + or -.</p>

<h2>Parameters</h2>
<ul>
	<li><p><b>item</b> - an item record already fetched from the database.  If
	you haven't fetched the item but you have the SKU, you can use the <code>sku</code> 
	parameter instead.</p>

	<li><p><b>sku</b> - if <code>item</code> is not provided, this parameter is
	required, as the sku code to fetch from the database.</p>

	<li><p><b>no_dropdown</b> - with this parameter set to a true value, no dropdowns
	will be displayed.  However, if the item has exactly one color choice, a hidden
	field will be included, so that color choice is automatically selected.</p>

	<li><p><b>show_single</b> - with this parameter set to a true value, an item with
	a single color choice will have that color choice displayed instead of the dropdown.</p>

	<li><p><b>default_selection</b> - with this parameter passed either via a URL or
	directly you can pre-select the color option in the drop-down list. </p>

	<li><p><b>as_list</b> - with this parameter set, <em>no output is displayed.  </em> 
	Instead, a list of color choices is returned as a listref.  Each color choice has a 
	name and (optionally:) a comma, sign and upcharge(/discount) amount. For example:</p>
	
	<pre>[Choice 1] Blue
[Choice 2] Green
[Choice 3] Silver, +3.00
</pre>
</ul>
<h3>Special Usage: Getting the number of color choices</h3>

<p>By calling this module with $m->comp(), you can determine how many color choices 
are available, while also letting this module display those choices (as appropriate for
the selected settings):

<pre>Color: 
<% <<EOD
\% my \$count = 
\%   \$m->comp('/store/shop/color_choices.m', 
\%   sku => 'FOO', <other parms> );
Found <\% \$count %\> choices
EOD
 |h
%></pre>

...or, if you want to avoid the Color: label in case of no color choices:

<pre><% <<EOD
\% my \$choices;
\% if( my \$count = 
\%    \$m->comp('/store/shop/color_choices.m', 
\%    sku => 'FOO', <other parms>,
\%    STORE => \\\$choices
\% ) ) {
Color: <\% \$choices %\>
\% }
EOD
 |h
%></pre>



</%method>
<%args>
$item => undef
$sku => undef
$as_list => undef
$no_dropdown => 0
$show_single => 0
$default_selection => undef
</%args>
<%init>
die "sku or item required" unless $item || $sku;
$sku =~ s/.*: (.*)/$1/; # package type isn't relevant to color choices
$item ||= mc_comp( 'fetch_item.m', sku => $sku );
my $color_choices = $item->{color};
$color_choices =~ s/\cM//g; 
$color_choices = [ split "\n", $color_choices ];

return $color_choices if $as_list;
return undef if $#$color_choices == -1;
</%init>
% if( !$item ) {
<!-- color_choices.m: sku <% $sku %>: item not found! -->
% }
%		my $fmt = sub {
%			my $p = shift;
%			$p = sprintf( "%+.2f", $p );
%			$p =~ s/([+-])/$1 \$/ if 0 + $item->{price};
%			$p =~ s/([+-])/\$/ unless 0+ $item->{price};
%			return $p;
%		};
% 		if( $#$color_choices > 0 ) {
%			return if $no_dropdown;
			<SELECT name="color_<% $item->{sku} %>">
%			foreach my $this_color( @$color_choices ) {
%				chomp $this_color;
%				my( $c, $p ) = split( ',', $this_color );
%				if( $p ) {
%					$p = $fmt->( $p );
%					$this_color = "$c ($p)";
% 				}
%				if ( lc($default_selection) eq lc($c) ) {
				<OPTION value="<% $c %>" selected><% $this_color %>
%				} else {
				<OPTION value="<% $c %>"><% $this_color %>
%				}
				
%			}
			</SELECT>
% 		} elsif( $#$color_choices == 0 ) {
%			my $c = $item->{color};
%			my $p;
%			chomp $c;
%			($c, $p ) = split( ',', $c );
%			if( $p ) {
%				$p = $fmt->( $p );
<%				"$c ($p)" %> \
%			} elsif( $show_single ) {
<%				$c %>
%			}
<%			%><INPUT type=hidden name=color_<% $item->{sku} %> value="<% $c %>">
% 		}
%	return ( $#$color_choices + 1 );

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

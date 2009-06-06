<%method .doc_synopsis>
Module responsible for formatting invoices.  Not used directly by end users.
</%method>
<%method .doc>
<h2>Usage</h2>
<p>This module is used by various parts of the web store.  The settings available 
for this module are controlled primarily by options set in your 
<code>/store/custom_options.m</code>.  See the documentation for
<a href="/doc.html?module=/store/options.m"><code>/store/options.m</code></a>
for technical information on setting up custom options.  Available options 
are stored in the 'style' option, which is a hash of settings named:
</p>

<ul>
	<li><p><b>header_color</b>: Specifies the background color of the table 
	header used for column labels. Default: dark grey (#999999)</p>

	<li><p><b>header</b>: Specifies the CSS style used for the table header 
	cells.  The default provides a 1-pixel black bottom border.</p>

	<li><p><b>odd_color</b>: Specifies the background color of odd-numbered
	table rows.  Default: white (#ffffff)</p>

	<li><p><b>even_color</b>: Specifies the background color of even-numbered
	table rows.  Default: light grey (#cccccc)</p>

	<li><p><b>odd</b>: Specifies the CSS style used for cells in odd-numbered 
	table rows.  Default: none</p>

	<li><p><b>even</b>: Specifies the CSS style used for cells in even-numbered 
	table rows.  The default provides a thin line above and below the cell,
	the same color as the even cells, along with padding adjustments to provide 
	a printable line between rows, that's not visible onscreen.</p>
	
	<li><p><b>footer_color</b>: Specifies the color of the footer area of the 
	invoice, including the subtotal line.  Default: dark grey (#999999)</p>

	<li><p><b>subtotal</b>: Specifies the CSS style used for cells in the Subtotal
	row immediately following the even/odd rows described above.  The default provides
	a thin black top border.</p>

	<li><p><b>footer</b>: Specifies the CSS style used for other cells in the footer 
	area.  Default: none </p>
</ul>

<p>You may include a + sign at the beginning of your custom CSS style, which will
add your style to the end of the default style. </p>

<p>You may also include the content of a different style into any other style.  Include 
the other style's label (one of the labels above) into the current style, surrounded 
by % signs - see the example.</p>

<h2>Example</h2>

<p>In /store/custom_options.m:</p>
<pre><% <<EOD
...
style => {
  header_color => '#9999ff', # blue background
  footer_color => '#ffffff', # white background
  footer => '+color:#000066',# dark blue text
  even_color => '#ccccff',   # lt blue background
  odd => '+color:%even_color%' # lt blue text
},
...
EOD
 |h %></pre>
</%method>

<%args>
$order
$with_links => 1
$with_header => 1
$with_prices => 1
</%args>
<%once>
my $DEBUG = 0;
</%once>
<%init>
$m->comp( "/session.m" );
my $user = $order->{user};
my $items = $order->{items};
</%init>

% if( $with_header ) {
% 	# use my caller's .invoice_header component
% 	my $header = $m->callers(1)->subcomps('.invoice_header' ) 
%		# or, failing that, this default one:
%		|| $m->callers(0)->subcomps('.invoice_header');
<& $header, order => $order &>
<%def .invoice_header>
<%args>
$order
</%args>
	<!-- Begin Invoice Info -->
	<p>
	<span class="ProdSpecTitle">Invoice #:</span>&nbsp;<span class="CartText"><% $order->{order_number} %></span><br>
% if( defined $order->{complete} && $order->{complete} == 0 ) {
	<font color=red>Incomplete Order: <% $order->{cc_result} %></font><br>
% }
	<span class="ProdSpecTitle">Date:</span>&nbsp;<span class="CartText"><& .date, date => $order->{date} &></span><br>
	<span class="ProdSpecTitle">Card Number:</span>&nbsp;<span class="CartText"><% $order->{card}{number} %></span><br>
	<span class="ProdSpecTitle">Expiration Date:</span>&nbsp;<span class="CartText"><% $order->{card}{expire} %></span>
	<!-- End Invoice Info -->
	<br><span class="ProdSpecTitle">Order Taken By:</span>&nbsp;<span class="CartText"><% $session->{store}{salesperson} %></span>

</%def>
% }
<p>

% my $styles = $m->comp('/store/style.m' );

<!-- Begin Shipping Information -->
<TABLE cellSpacing=0 cellPadding=2 border=0 cols="5" class="CartText" align=center>
	<TR>
		<TD width=1></td>
		<TD width=1></td>
		<TD width=140></td>
		<TD width=1></td>
		<TD width=1></td>
		<TD width=1></td>
	</TR>
<tr><td colspan=5>
<table border=0 class="CartText" ALIGN="center">
	<tr><td><nobr>BILL TO: 
		<% $with_links ? ' [<a href="/store/checkout.html">Edit</a>]' : '' %>
		</nobr>
	</td><td width=75>&nbsp;</td>
	<td><nobr>SHIP TO: 
		<% ( $with_links && ! $m->comp('/store/options.m', option => 'no_shipping' ) ) ? '[<a href="/store/checkout.html?which=ship">Edit</a>]' : '' %>
		</nobr>
	</td></tr>

	<tr>
		<td><nobr><% $user->{bill_first} ? ( $user->{bill_first} . " " . $user->{bill_last} ) : $order->{billto_name} %></nobr></td>
		<td>&nbsp;</td>
		<td><nobr><% $user->{ship_first} ? ( $user->{ship_first} . " " . $user->{ship_last} ) : $order->{shipto_name} %></nobr></td>
	</tr><tr>
% if( $user->{bill_company} || $order->{billto_company} ||
%	  $user->{ship_company} || $order->{shipto_company} ) {
		<td><nobr><% $user->{bill_company} || $order->{billto_company} %></nobr></td>
		<td>&nbsp;</td>
		<td><nobr><% $user->{ship_company} || $order->{shipto_company} %></nobr></td>
	</tr><tr>
% }
		<td><nobr><% $user->{bill_address1} || $order->{billto_addr1} %></nobr></td>
		<td>&nbsp;</td>
		<td><nobr><% $user->{ship_address1} || $order->{shipto_addr1} %></nobr></td>
	</tr><tr>
% if( $user->{bill_address2} || $order->{billto_addr2} ||
%	  $user->{ship_address2} || $order->{shipto_addr2} ) {
		<td><nobr><% $user->{bill_address2} || $order->{billto_addr2} %></nobr></td>
		<td>&nbsp;</td>
		<td><nobr><% $user->{ship_address2} || $order->{shipto_addr2} %></nobr></td>
	</tr><tr>
% }
		<td><nobr><% $user->{'bill_city'} || $order->{billto_city} %>, 
			<% $user->{'bill_state'} || $order->{billto_state} %> 
			<% $user->{'bill_zip'} || $order->{billto_zip} %></nobr></td>
		<td>&nbsp;</td>
		<td><nobr><% $user->{'ship_city'} || $order->{shipto_city} %>, 
			<% $user->{'ship_state'} || $order->{shipto_state} %>
			<% $user->{'ship_zip'} || $order->{shipto_zip} %></nobr></td>
	</tr>
% if( $user->{bill_country} || $order->{billto_country} ||
% 	  $user->{ship_country} || $order->{shipto_country} ) {
	<tr>
% my $countries = $m->comp('/store/countries.m');
		<td><% $countries->{ $user->{bill_country} || $order->{billto_country} } %></td>
		<td>&nbsp;</td>
		<td><% $countries->{ $user->{ship_country} || $order->{shipto_country} } %></td>
	</tr>
% }
% if( $order->{billto_phone} || $order->{shipto_phone} ) {
	<tr>
		<td><% $order->{billto_phone} %></td>
		<td>&nbsp;</td>
		<td><% $order->{shipto_phone} %></td>
	</tr>
% }
% if( $order->{billto_email} || $order->{shipto_email} || $user->{bill_email} || $user->{ship_email} ) {
	<tr>
%	my $e = $user->{bill_email} || $order->{billto_email};
%	my $company_name = $m->comp('/store/options.m', option => "company_name" );
		<td><a href="mailto:<% $e %>?subject=<% $company_name %> order #<% $order->{order_number} %>"><% $e %></a></td>
		<td>&nbsp;</td>
%	$e = $user->{ship_email} || $order->{shipto_email};
		<td><a href="mailto:<% $e %>?subject=<% $company_name %> order #<% $order->{order_number} %>"><% $e %></a></td>
	</tr>
% }
% if( $user->{bill_po_num} || $order->{billto_po_num} ) {
<tr>
		<td colspan=3><br><nobr>Purchase Order Number: <% $user->{bill_po_num} || $order->{billto_po_num} %></nobr></td>
	</tr>
% }
</table>
<!-- End Shipping Information -->
<br>
</td></tr>
	<TR class=t_header>
		<TD align=center class="t_header">Item&nbsp;#</TD>
		<TD align=center class="t_header">Qty</TD>
		<TD align=center width=140 class="t_header">Description</TD>
		<TD align=center class="t_header">Tax</td>
%	if( $with_prices ) {
		<TD align=center class="t_header">Price</TD>
		<TD align=center class="t_header">Total Price</TD>
%	}

	</TR>
% my( $subtotal, $tax, $total );
% my( $skus, $lookup );
%
% my $tax_rate = ( $order->{price}{tax_rate} * 100 ) || ( $order->{tax_rate} * 100 ); 
% my $tax_state = uc( $order->{price}{tax_state} || $order->{tax_state} || 'CA' );
% $tax_rate && ( $tax_rate .= "%" );
% $tax_rate ||= '';
%
% unless( $items->[0]{price} ) {
%	warn "looking up item details in database: ". Data::Dumper::DumperX( $items ) if $DEBUG;
%	$lookup = sub { 
%		my $item = shift @_;
%		my $quantity = $item->{quantity};
%		my $sql = "select sku, short_description, ".
%			$dbh->quote( $item->{extra_description} ). " as extra_description, ".
%			$dbh->quote( $quantity ) ." as quantity, price, taxable, ".
%			$dbh->quote( $item->{color} ) . " as color ".
%			" from product where sku=" . $dbh->quote( $item->{sku} );
%
%		warn "   ($item->{sku}): $sql" if $DEBUG;
%		my $rec = $m->comp('/db_fetch.m', query => $sql );
%		$rec = $rec->[0];
%		my $pr =  $rec->{price} + $item->{upcharge} - $item->{discount};
%		$rec->{price} = sprintf( "%.2f", $pr );
%		$rec->{price_ext} = sprintf( "%.2f", int( 100 * $rec->{quantity} * $pr + 0.5 )/100 );
%		return $rec;
%	};
% } else {
%	$lookup = sub { shift };
% }
% my $flip = 0;
% my $total_quantity = 0;
% for my $item ( @$items ) {
% 	$flip = 1 - $flip;
%	my $class = 't_row_' . ( $flip ? "odd" : "even" );
% 	my $detail = $lookup->( $item );
	<TR>
		<TD align=center class="<% $class %>"><nobr><% $detail->{sku} %></nobr></TD>
%	$total_quantity += $detail->{quantity};
		<TD align=center class="<% $class %>"><% $detail->{quantity} %></TD>
		<TD align=left class="<% $class %>"><% $detail->{'short_description'} %>\
% 	if( $item->{color} ) {
 (<% $item->{color} %>)\
% 	}
%	my $custom_fields = $m->comp( '/store/options.m', option => 'shop_custom_fields_global' ) || [];
%	foreach my $f( @$custom_fields ) {
 (<% ucfirst lc $f |h %>: <% $item->{$f} |h %>)\
% 	}
</TD>
		<TD align="center" class="<% $class %>"><% ( $detail->{taxable} && $tax_rate ) ? "x" : "&nbsp;" %></td>
%	if( $with_prices ) {
		<TD align=center class="<% $class %>">$<% $detail->{'price'} %></TD>
		<TD align=right class="<% $class %>">$<% $detail->{price_ext} %></TD>
%	}
</TR>
% 	if( $item->{extra_description} ) {
<tr><td class="<% $class %>" colspan=2>&nbsp;</td>
	<td colspan=3 class="<% $class %>"><% $item->{extra_description} |h %></td>
	<td class="<% $class %>">&nbsp;</td>
	</tr>
% 	}
% }
% if( $with_prices ) {

% if( 0 + $order->{discount_pretax} ) {
	<TR>
			<TD align=right colSpan=5 class="t_footer">Discount (pretax):&nbsp;</TD>
			<TD align=right class="t_footer">&lt;&nbsp;$<% sprintf( "%.2f", $order->{discount_pretax} ) %>&nbsp;&gt;</TD>
	</TR>
% }
	<TR>
			<TD align=right colSpan=5 class="t_row_subtotal">Subtotal: </TD>
			<TD align=right class="t_row_subtotal">$<% $order->{price}{subtotal} || $order->{subtotal} %></TD>
	</TR><TR>
			<TD align=right colSpan=5 class="t_footer"><% $with_links ? '<a href="/store/credit_card.html">Shipping and Handling</a>' : 'Shipping and Handling' %> \
%
<%perl>
{
 	my $mod = $m->comp( '/store/options.m', option => 'shipping_module' );
	unless( defined $mod ) {
		$m->out("DEVELOPMENT ERROR: custom option 'shipping_module' not found!" );
 	} elsif( $mod ) {
		my $shipping_desc = $m->comp( $mod, fetch => 'descriptions' );
		$m->out( "(". ( $shipping_desc->{ $order->{shipping_method} } || $order->{shipping_method}  ) . "):&nbsp;" );
 	} else {
	}
}
</%perl>
</TD>
% my $shipping = $order->{price}{shipping} || $order->{shipping_cost};
% my $handling = $order->{price}{handling} || $order->{handling_fee};
			<TD align=right class="t_footer">$<% sprintf( "%.2f", $shipping + $handling ) %></TD>
% if( 0+ ( $order->{price}{tax} || $order->{tax_amount} ) ) {
	</TR><TR>
			<TD align=right colSpan=5 class="t_footer"><% $tax_rate %> Sales Tax (<% $tax_state %> Residents):&nbsp;</TD>
			<TD align=right class="t_footer">$<% $order->{price}{tax} || $order->{tax_amount} %></TD>
% }
% if( 0 + $order->{discount_posttax} ) {
	</TR><TR>
			<TD align=right colSpan=5 class="t_footer">Discount (post-tax):&nbsp;</TD>
			<TD align=right class="t_footer">$<% sprintf( "%.2f", $order->{discount_posttax} ) %></TD>
% }
	</TR><TR>
			<TD align=right colSpan=5 class="t_footer">TOTAL:&nbsp;</TD>
			<TD align=right class="t_footer"><span class="CartTotal">$<% $order->{price}{total} || $order->{total} %></span></TD>
	</TR>
% } else {
	<TR>
			<TD align=right colSpan=4 class="t_row_subtotal">&nbsp;</td>
	</tr>
% }
<TR><TD><% $total_quantity %> item<% $total_quantity > 1 ? "s" : "" %> on order</td></tr>
</TBODY></TABLE>

<%def .date>
<%args>
$date
</%args>
% use Date::Manip;
% my $t = UnixDate( ParseDate( "epoch $date" ), "%B %d, %Y" );
<% $t %>
</%def>


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

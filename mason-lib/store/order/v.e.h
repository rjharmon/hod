<%method .doc_synopsis>End-User-Visible Invoices</%method>
<%method .doc>
<h2>Usage</h2>

<pre><% $server_name %>/store/order/v.e.h?i=<i>invoice-number</i></pre>

<p>By sending users to the above URL, you can provide a view into their 
</%method>
<%args>
$i => undef
$cc => undef
$DEBUG => 0
</%args>
% return unless $i;

<%method end_user>
</%method>

<%method HEADER_VMENU></%method>
<%shared>
my $error = 0;
my $order;
use Date::Manip;
</%shared>

<%method authenticate>
<%init>
$m->comp('/session/validate.m') or return undef;
return $m->comp('/db_single_item.m',
	query => "select count(*) from orders where order_number=? AND billto_email=?",
	args => [ $ARGS{i}, $session->{vcode_email} ],
);
</%init>
</%method>


<%init>

$m->base_comp->call_method('authenticate', %ARGS) || return 301;

$order = $m->comp( '/db_fetch.m', query => "select * from orders where order_number=". $dbh->quote( $ARGS{'i'} ) );
$order = $order->[0] or $error = 1;
if( $cc && ! $error ) {
	warn "sending CC info..." if $DEBUG;
	$m->clear_buffer();

	$r->content_type( 'application/octet-stream' );
	$r->header_out( 'Content-Disposition' => "attachment; filename=$order->{order_number}.pgp" );

	$m->out($order->{cc_info});
	$m->abort();
}
$order->{items} = $m->comp('/db_fetch.m', query => "select * from order_item where order_number=". $dbh->quote( $ARGS{'i'} ) );
</%init>

<%def .invoice_header>
<%args>
$order
</%args>
<span class="Search">Invoice #:&nbsp;<% $order->{order_number} %><% $order->{dev_only} ? " - Dev-Only" : "" %> </span>\
% if( defined $order->{complete} && $order->{complete} == 0 ) {
<p><span class="FormError">Incomplete Order: <% ucfirst lc $order->{cc_result} %></span><br>
% }
<br>
<span class="CartTotal">Purchase Date:</span>&nbsp;<% UnixDate( ParseDate( $order->{purchase_date} ), "%B %d, %Y" ) %><br>
<span class="CartTotal">Card Number:</span>&nbsp;<% "xxxx-xxxx-xxxx-". $order->{cc_last4} %><br>
<span class="CartTotal">Originating IP:</span>&nbsp;<% $order->{ip_address} %><br>

<span class="CartTotal">Credit Card Result:</span>&nbsp;<% ucfirst lc $order->{cc_result} %>
% if( $order->{cc_info} && ! $m->base_comp->method_exists('end_user') ) {
<a href="v.html?cc=1.pgp&i=<% $order->{order_number} |u %>">Fetch</a>
% }
% if( $order->{salesperson} ) {
	<br><span class="ProdSpecTitle">Order Taken By:</span>&nbsp;<span class="CartText"><% $order->{salesperson} %></span>
% }

</%def>


% if( $error ) {
Order number <% $i %> not found.
% } else {
<& invoice.m, order => $order, with_links => 0 &>
% }

<%def CONTENT_TITLE>
Invoice
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

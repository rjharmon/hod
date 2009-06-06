<%method .title>
Shipping Price Calculator (tiered by sale price)
</%method>
<%method .doc_synopsis>
Provide tiered shipping options, where costs are scaled based on the dollar amount of the products being ordered.
</%method>
<%method .doc>
<h2>Usage</h2>
<p>In <code>/store/options.m</code>, define an option for 
<code>shipping_module</code>, pointing to '/store/shipping/sale_price_table.m':</p>

<p>Also, define <code>shipping_table_options and shipping_table_descriptions</code>,
as described below.  For example:

<pre><% <<EOD
...
shipping_module => '/store/shipping/sale_price_table.m',
shipping_table_descriptions => {
  '01' => 'Standard Shipping',
  '02' => 'Priority Shipping',
  '03' => 'Overnight Express',
},
shipping_table_options => {
    '01' => {
        0 => 3,
        50 => 5,
        60 => 10,
        100 => 20,
        200 => 10,
        300 => 0,
    },
    '02' => {
        0 => 10,
        100 => 20,
        200 => 25,
        300 => 30,
    },
    '03' => {
        0 => 20,
        300 => 0,
    },
},
...
EOD
 |h %></pre>

<h2>Defining Shipping Cost Tables</h3>

<p>There are two parts to defining shipping costs.  First, identify
the different shipping methods you'll use, and define codes and
descriptions for them, as shown in the example above.  Second, decide
how much to charge for what shipping cost. </p>

<p>For each shipping method, you can define any combination of tiers
for shipping prices.  You can charge more as the order size grows, or
you can charge less as the order size grows.  It's up to you.  </p>

<p>Start by defining how much your cheapest items will cost your
customer to ship, and put a zero label on that (the first line of
each shipping table in the example starts with a zero, and so the
prices for shipping the smallest product are $3, $10, $20 and $300,
depending on the shipping method selected.  </p>

<p>The next line specifies the dollar level above which the shipping 
price is different.  Notice that for overnight shipping, a $300 order
gives the customer free shipping.  </p>

<p>And so it continues: each line of each shipping table gives another
pricing tier, above which the new price is applied.</p>

<p>When shipping options are displayed to the customer, the current 
order's subtotal is looked up in each table, determining the shipping 
price for each shipping method.  Each option is presented to the 
customer, labeled with the description from the description table and
with the shipping price determined for the specified order quantity.
</p>

<p>Note that the example has a flaw in it - if the order is over $300,
overnight shipping is free where as priority shipping is $30.  This
is perfectly acceptable to this module, but common sense may dictate
whatever policy you would prefer.</p>

<p>For simpler, but less flexible, shipping prices, try 
<a href="/doc.html?module=/store/shipping/simple.m"><code>simple.m</code></a>.</p>
</%method>

<%args>
$fetch => 'options'
</%args>
<%init>
return $m->comp( '.description', %ARGS ) 
	if( $fetch eq 'desc' || $fetch eq 'description' || $fetch eq 'descriptions' );

my $price = $m->comp( '/store/order/calc_pricing.html',
	order => {
		items => $session->{store}{cart}{items},
	}
)->{subtotal};

my $ops = $m->comp( '/store/options.m', option => 'shipping_table_options' );

my $options = {};

# warn "price: $price; ops: ". Data::Dumper::Dumper( $ops );

foreach my $op( keys %$ops ) {
	my $pr = 0;
#	warn "  Checking method $op\n";
	foreach my $amount( sort { $a <=> $b } keys %{ $ops->{$op} } ) {
		# warn "     $amount\n";
		$pr ||= ( $ops->{$op}{$amount} ); # ensure that a low-price order has a cost
		( $pr = $ops->{$op}{$amount} ), 
			0 # warn( "             (yep)\n") 
			if $price > $amount; 
	}
	$options->{$op} = $pr;
}
# warn "options: ". Data::Dumper::Dumper( $options );
return $options;

</%init>

<%def .description>
<%args>
$code => undef
</%args>
<%init>
my $d =  $m->comp( "/store/options.m", option => 'shipping_table_descriptions', required => 1 );
return $d unless $code;
return $d->{$code};
</%init>
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

<%method .title>
Shipping Price Calculator (flat fees)
</%method>
<%method .doc_synopsis>Provide simple shipping options, using a flat fee for each shipping method.
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
    '01' => 3.00,
    '02' => 10.00,
    '03' => 20.00,
},
...
EOD
 |h %></pre>

<h2>Defining Simple shipping options</h2>

<p>There are two parts to defining shipping costs.  First, identify
the different shipping methods you'll use, and define codes and
descriptions for them, as shown in the example above.  Second, decide
how much to charge for what shipping cost. </p>

<p>For each shipping method, simply specify the price to charge
for shipping via that method, using the example as a template.
</p>

<p>When shipping options are displayed to the customer, the 
table is used to present the options to the customer,
customer, labeled with the description from the description table and
with the shipping price listed for that shipping method.</p>
</p>

<p>For shipping based on price, try 
<a href="/doc.html?module=/store/shipping/sale_price_table.m"><code>sale_price_table.m</code></a>.</p>

</%method>
<%args>
$fetch => 'options'
</%args>
<%init>
return $m->comp( '.description', %ARGS ) 
	if( $fetch eq 'desc' || $fetch eq 'description' || $fetch eq 'descriptions' );

return $m->comp( "/store/options.m", option => 'shipping_simple_options', required => 1 );
</%init>

<%def .description>
<%args>
$code => undef
</%args>
<%init>
my $d = $m->comp( "/store/options.m", option => 'shipping_simple_descriptions', required => 1 );
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

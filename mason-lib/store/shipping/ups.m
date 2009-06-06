<%method .title>
Shipping Price Calculator (UPS)
</%method>
<%method .doc_synopsis>(PLACEHOLDER) For calculating shipping options by querying UPS
</%method>
<%method .doc>
<h2>Usage</h2>
<p>In <code>/store/options.m</code>, define an option for 
<code>shipping_module</code>, pointing to '/store/shipping/ups.m':</p>

<p>This is currently useful for displaying shipping types defined by UPS.  If you need
UPS shipping calculations for your web store, please email <& /email_display.m, email => 'support' &>
and we will create a UPS e-shipping account for your web site.
</p>
</%method>
<%args>
$fetch => 'options'
</%args>
<%init>
return $m->comp( '.description', %ARGS ) 
	if( $fetch eq 'desc' || $fetch eq 'description' || $fetch eq 'descriptions' );

my $settings = $m->comp( "/store/options.m", option => 'shipping_ups_options', required => 1 );

foreach( qw(license userid password shipper_zip) ) {
	die( "UPS Shipping: /store/options.m: shipping_ups_options->{$_} is required." )
		unless $settings->{$_};
}

my $weight = $m->comp( '/store/order/calc_pricing.html',
	order => {
		items => $session->{store}{cart}{items},
	}
)->{weight};

# ! ? allow an item to specify a box size and "ship separately" option?  If
#     so, calculate multiple package prices and combine them for a total
#     price.
my $opt = $m->comp('ups_options.m', 
	type => 'shop',
	package_type => '02',  # ! allow custom package types someday?
	pickup_code => '01',
	markup => 0,

	%$settings,
	package_weight => 0 + $weight || "1",
	shipto_zip => $session->{store}{user_address}{ship_zip},
	shipto_country => $session->{store}{user_address}{ship_country}
);

return $opt if $fetch eq 'info';
return { map { $_ => $opt->{$_}{TotalCharges}{MonetaryValue} } keys %$opt };

</%init>

<%def .description>
<%args>
$code => undef
</%args>
<%init>
my $d = {
	'01' => 'Next Day Air',
	'02' => '2nd Day Air',
	'03' => 'Ground',
	'07' => 'Worldwide Express',
	'08' => 'Worldwide Expedited',
	'11' => 'Standard',
	'12' => '3 Day Select',
	'13' => 'Next Day Air Saver',
	'14' => 'Next Day Early AM',
	'54' => 'Worldwide Express Plus',
	'59' => '2nd Day Air AM',
};
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

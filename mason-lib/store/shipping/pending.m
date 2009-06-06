<%flags>
inherit => '/db_query.m'
</%flags>

<%method select_records>
os.*, orders.purchase_date
</%method>

<%method query>
from order_shipment os, orders where NOT ( os.status in ('Shipped', 'Received' ) )
AND orders.order_number=os.order_number 
% unless( $dev ) {
AND orders.dev_only <> 'x'
% }
</%method>

<%method options><%init>
return {
	definition => '/store/shipping/definition.m'
};
</%init>
</%method>
<%method pager_top>
<& PARENT:pager_top, %ARGS &>
<tr class="thick_bottom site_trim_background">
<th>Order Number</th>
	<th>Date</th>
		<th>From</th>
			<th>To</th>
				<th>Status</th>
</tr>
</%method>


<%method pager_item>
<td>
% my $e = $m->fetch_comp( 'edit.html' );
% if( $m->comp( $e->subcomps('.allow_edit'), %ARGS ) ) {
	<a href="/store/shipping/edit.html?id=<display name=id>"><display name=order_number></a>
% } else {
	<display name=order_number>
% }
</td>
	<td><display name=purchase_date></td>
		<td><display name=from_name><br>
		<display name=from_city>, <display name=from_state>
		</td>
			<td><display name=to_name><br>
			<display name=to_city>, <display name=to_state>
			</td>
				<td><display name=status></td>
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

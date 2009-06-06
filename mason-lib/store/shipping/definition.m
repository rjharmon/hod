<%init>
$m->comp('/session.m');
my $is_admin = $session->{site_admin} || $session->{store_admin};
return ( {
	id			=> ID,
	order_number		=> TEXT,

	status 			=> PULLDOWN,
	
	tracking_number 	=> TEXT,

	to_name 		=> TEXT,
	to_company		=> TEXT,
	to_addr1	 	=> TEXT,
	to_addr2	 	=> TEXT,
	to_city			=> TEXT,
	to_state		=> TEXT,
	to_zip			=> TEXT,
	to_country		=> TEXT,
	to_email		=> TEXT,
	to_phone		=> TEXT,

	vendor			=> ID,

	from_name 		=> TEXT,
	from_company		=> TEXT,
	from_addr1	 	=> TEXT,
	from_addr2	 	=> TEXT,
	from_city		=> TEXT,
	from_state		=> TEXT,
	from_zip		=> TEXT,
	from_country		=> TEXT,
	from_email		=> TEXT,
	from_phone		=> TEXT,

	history			=> TEXTBOX,

},{
	table => 'order_shipment',
	primary => 'id',
	required => [ qw(order_number from_zip to_zip) ],
	keys => {
		by_order => 'order_number',
	},

	status => [ qw(Pending Packaged Shipped Received Refused) ],
}
);
</%init>




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

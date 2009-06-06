<%init>
return ( 
{
	order_number => TEXT,
	sequence => ID,
	sku => TEXT,
	short_description => TEXT,
	extra_description => TEXT,
	offer => TEXT,
	color => TEXT,
	quantity => NUMBER,
	price => MONEY,
	price_ext => MONEY,
	tstamp => DATE,
	discount => MONEY,
	
	shipment => ID,

	pending_return_qty => NUMBER,
	completed_return_qty => NUMBER,

}, {
	table => 'order_item',
	primary => [ qw(order_number sequence) ],
}, {
	order_number			=> 'varchar(20) NOT NULL default ""',
	sequence			=> 'int(11) NOT NULL',

	sku				=> 'varchar(30) NOT NULL default ""',
	short_description		=> 'varchar(255) NOT NULL',
	extra_description		=> 'varchar(255) default NULL',

	pending_return_qty		=> 'int(11) NOT NULL',
	completed_return_qty 		=> 'int(11) NOT NULL',

	offer 				=> 'varchar(25) default NULL',

	color				=> 'varchar(30) default NULL',

	quantity			=> 'int(11) NOT NULL',
	price				=> 'decimal(8,2) NOT NULL',
	price_ext			=> 'decimal(8,2) NOT NULL',

	tstamp				=> 'timestamp(14) NOT NULL',
	discount			=> 'decimal(8,2) default NULL',
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

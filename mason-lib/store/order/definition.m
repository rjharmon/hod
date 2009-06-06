<%init>
$m->comp('/session.m');
my $is_admin = $m->comp('/session/is_admin.m', area => 'Store Orders - Administration',
	role => [ 'site_admin', 'orders_admin', 'orders_view_list' ],
	silent => 1
);
my $view_prices = $m->comp('/session/is_admin.m', area => 'Store Orders - View Prices',
	role => [ 'site_admin', 'orders_admin', 'orders_view_pricing' ],
	silent => 1
);
my $finances = $m->comp('/session/is_admin.m', area => 'Store Orders - View Prices',
	role => [ 'site_admin', 'orders_admin', 'finance_view_monthly_report' ],
	silent => 1
);
my @normal_fulfill_status = ( 'Pending', 'Partial', 'Fully Shipped', 'Received' );

return ( {
	order_number		=> TEXT,
	
	is_return		=> CHECKBOX,

	tstamp			=> DATE,
	purchase_date 		=> DATE,
	dev_only		=> CHECKBOX,
	complete		=> CHECKBOX,
	commissions_billed	=> CHECKBOX,

	billto_name 		=> TEXT,
	billto_company		=> TEXT,
	billto_po_num		=> TEXT,
	billto_addr1	 	=> TEXT,
	billto_addr2	 	=> TEXT,
	billto_city		=> TEXT,
	billto_state		=> TEXT,
	billto_zip		=> TEXT,
	billto_country		=> TEXT,
	billto_email		=> TEXT,
	billto_phone		=> TEXT,

	shipto_name		=> TEXT,
	shipto_company		=> TEXT,
	shipto_addr1 		=> TEXT,
	shipto_addr2 		=> TEXT,
	shipto_city		=> TEXT,
	shipto_state		=> TEXT,
	shipto_zip		=> TEXT,
	shipto_country		=> TEXT,
	shipto_email		=> TEXT,
	shipto_phone		=> TEXT,

	subtotal			=> MONEY,
	discount_pretax			=> MONEY,
	tax_area			=> TEXT,
	tax_rate			=> MONEY,
	tax_amount			=> MONEY,
	tax_state			=> TEXT,

	shipping_method 		=> TEXT,
	shipping_cost			=> MONEY,
	discount_posttax		=> MONEY,
	handling_fee    		=> MONEY,
	total				=> MONEY,

	cc_name				=> TEXT,
	cc_last4			=> TEXT,
	cc_expire			=> TEXT,
	cc_type				=> TEXT,
	cc_result			=> TEXT,
	cc_info				=> TEXTBOX,
	cc_trans_id			=> TEXT,
	cc_warning			=> TEXT,

	auth_code			=> TEXT,
	reference_number		=> TEXT,

	ip_address			=> TEXT,
	dev_only			=> CHECKBOX,
	salesperson			=> TEXT,

	fulfillment_status		=> PULLDOWN,
},{
	primary => 'order_number',
	table => 'orders',
	required => [ qw(order_date) ],


	fulfillment_status => { 
		_order => [ '', @normal_fulfill_status ],
		'' => "Legacy - Completed",
		map { $_ => $_ } @normal_fulfill_status
	},

	filters => {
		_order => [ 'Result', 
			( $is_admin ? ( 
				'Year', 'Period', 'SalesPerson'
			) : ( 'Email' ) ),
			( $view_prices ? ( 'View As' ) : () ),
			( $finances ? ( 'Tax Rate' ) : () ),
		],
		"Result" => {
			type => $is_admin ? PULLDOWN : '',
			options => [
				'Success',
				'Failure',
				'All Attempts'
			],
			attrs => 'onChange="this.form.submit()"',
			where => sub {
				$_ = shift; my %ARGS = %$_;
				$_ = shift; my %QARGS = %$_;
				if( $is_admin ) {
					return "1" if $ARGS{Result} eq 'All Attempts';
					return "complete = 0 OR cc_result NOT LIKE 'success%'" if $ARGS{Result} eq 'Failure';
				}
				return "complete = 1 AND cc_result like 'success%'";
			},
			default => 'Success',
			help => "Allows you to view unsuccessful ordering attempts",
		},
		"Year" => {
			type => PULLDOWN,
			options => [
				'This Year',
				'All Years',
				@{ $m->comp( '/db_single_column.m', query =>
					"select distinct year(purchase_date) year from orders having year > 0"
				) },
			],
			default => 'This Year',
			attrs => 'onChange="this.form.submit()"',
			where => sub {
				$_ = shift; %ARGS = %$_;
				$_ = shift; my %QARGS = %$_;
				return 1 if $ARGS{Year} eq "All Years";
				return "year(purchase_date) = year(now())" if $ARGS{Year} eq "This Year";
				return "year(purchase_date) = ". $QARGS{Year} 
			},
		},
		Period => {
			type => PULLDOWN,
			options => {
				_order => [ qw(now all 1 2 3 4 5 6 7 8 9 10 11 12 Q1 Q2 Q3 Q4) ],
				'now' => 'This Month',
				'all' => 'All',
				'1' => 'Jan',
				'2' => 'Feb',
				'3' => 'Mar',
				'4' => 'Apr',
				'5' => 'May',
				'6' => 'Jun',
				'7' => 'Jul',
				'8' => 'Aug',
				'9' => 'Sep',
				'10' => 'Oct',
				'11' => 'Nov',
				'12' => 'Dec',
				'Q1' => 'Q1',
				'Q2' => 'Q2',
				'Q3' => 'Q3',
				'Q4' => 'Q4',
			},
			default => 'now',
			attrs => 'onChange="this.form.submit()"',
			where => sub {
				$_ = shift; %ARGS = %$_;
				$_ = shift; my %QARGS = %$_;
				return "month(purchase_date) = month(now())" if( $ARGS{Period} eq 'now' );;
				return 1 if $ARGS{Period} eq 'all';
				return "month(purchase_date) = $QARGS{Period}" if $ARGS{Period} =~ /^\d+$/;
				if( $ARGS{Period} =~ /Q(\d)/ ) {
					my $q = $1;
					return "quarter(purchase_date) = $q";
				}
			},
			help => "Choose a month or quarter for reporting",
		},

		'Tax Rate' => {
			type => PULLDOWN,
			options => {
				_order => [ 'All', '0.0000', '0.0725', '0.0737' ],
				All => "All Rates",
				'0.0000' => 'Tax Exempt',
				0.0725 => 'State Tax',
				0.0737 => 'Local Tax',
			},
			attrs => 'onChange="this.form.submit()"',
			where => sub {
				$_ = shift;
				my %ARGS = %$_;
				$_ = shift;
				my %QARGS = %$_;
				return '1' if $ARGS{'Tax Rate'} eq 'All';
				return "tax_rate = $ARGS{'Tax Rate'}" if( $ARGS{'Tax Rate'} );
				return '1';
			},
			help => <<EOD,
Select the tax rate for orders you wish to view.
EOD
		},
		'SalesPerson' => {
			type => PULLDOWN,
			options => [
				'All Sales',
				'Offline Orders',
				@{ 	$m->comp('/db_single_column.m', query => 
						"select distinct salesperson from orders having salesperson <> '' and salesperson is not null"
				) },
			],
			attrs => 'onChange="this.form.submit()"',
			where => sub {
				$_ = shift;
				my %ARGS = %$_;
				$_ = shift;
				my %QARGS = %$_;
				return "salesperson <> 'Web'" if $ARGS{'SalesPerson'} eq "Offline Orders";
				return "salesperson = $QARGS{'SalesPerson'}" unless $ARGS{'SalesPerson'} eq "All Sales";
				return "1";
			},
			label => 'Salesperson',
			help => <<EOD,
Select the salesperson whose orders you wish to view.
EOD
		},
		'Email' => {
			type => $is_admin ? TEXT : "",
			where => sub {
				my $vce = $dbh->quote($session->{vcode_email});
				return "billto_email=$vce" unless $is_admin;
				$_ = shift;
				my %ARGS = %$_;
				$_ = shift;
				my %QARGS = %$_;
				my $e = $ARGS{'Email'};
				$e =~ s/([%_'])/\\$1/g;
				return "billto_email like '%$e%'";
			},
			default => $is_admin ? '' : 'me',
			help => "Enter an email address or partial address to find",
		},
		'View As' => {
			type => PULLDOWN,
			attrs => 'onChange="this.form.submit()"',
			default => 'Report',
			options => [
				'Report',
				'Graph',
			],
			where => sub { "1" },
		}
	},
},{
	tstamp 				=> 'timestamp(14) NOT NULL',
} );
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

<%init>
return ( {
	id			=> ID,
	name			=> TEXT,

	default_vendor		=> CHECKBOX,

		tax_state	=> PULLDOWN,
		tax_county	=> TEXT,
		tax_rate_local	=> NUMBER,
		tax_rate_state  => NUMBER,
		global_merchant_account => CHECKBOX,

	addr1		 	=> TEXT,
	addr2		 	=> TEXT,
	city			=> TEXT,
	state			=> TEXT,
	zip			=> TEXT,
	country			=> TEXT,
	email			=> TEXT,
	phone			=> TEXT,

},{
	table => 'order_vendor',
	primary => 'id',
	required => [ qw(name addr1 city state zip phone) ],
	keys => {
		by_name => 'name',
	},
	tax_state => {
		_order => [qw(ca in)],
		'ca' => 'California',
		'in' => 'Indiana',
	},
},
{
	tax_rate_local => 'DECIMAL(7,5)',
	tax_rate_state => 'DECIMAL(7,5)',
}
);
</%init>



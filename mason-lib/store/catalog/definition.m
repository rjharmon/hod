<%method .title>
Store Catalog - Customizing
</%method>
<%method .doc_synopsis>
Record layout definition for your store catalog.
</%method>
<%method .doc>
<h2>Customizing your Store Catalog</h2>

<p>In addition to the standard fields for store catalogs, you may 
also choose to define some custom fields for addition data management
tasks.</p

<p>To define custom fields, create a <code>/store/catalog/custom_definition.m</code>
that returns your custom record definition.  For example:</p>

<pre><% <<EOD
<\%init>
return ( 
   {
      my_extra_field  => TEXT,
      another_field => PULLDOWN,
   },
   {
      another_field => [ qw(option1 option2 option3) ],
   }
);
</\%init>
EOD
 |h %></pre>

<p>If you don't have any custom fields, you can provide custom options for certain 
fields by leaving an empty placeholder:</p>

<pre><% <<EOD
<\%init>
return ( 
   {
   },
   {
      another_field => [ qw(option1 option2 option3) ],
   }
);
</\%init>
EOD
 |h %></pre>

For more information, see <a href="/doc.html?module=/record_definition.html">the 
record definition help page</a>.
</%method>
<%init>
use Hod::DB;
return $m->comp('/custom_definition.m', 
	custom_path => '/store/catalog/custom_definition.m',
	base => [
{
	sku => TEXT,

	category => PULLDOWN,
	sub_category => PULLDOWN,

	short_description => TEXT,
	long_description => TEXTBOX,
	color => TEXTBOX,
	price => MONEY,

	active => CHECKBOX,
	hot_item => CHECKBOX,
	taxable => CHECKBOX,
	weight => NUMBER,

	product_uri => TEXT,

	small_pic => FILE_UPLOAD,
	small_pic_size => TEXT,
	large_pic => FILE_UPLOAD,
	large_pic_size => TEXT,

	handling_fee => MONEY,
	offline => CHECKBOX,
	vendor => PULLDOWN,
	pending_review => CHECKBOX,

	change_log => TEXTBOX,
}, 
{
	primary => 'sku',
	table => 'product',
	required => [ 
		qw(category sub_category sku
		   short_description long_description
		   price)
	],
	category => [
		map( { $_->{category} } @{
			 $m->comp( '/db_fetch.m', query => 
				"select distinct category from product where category<>'' ORDER BY category"
			) || [],
		} ),
		'Add Category'
	],
	sub_category => [
		map( { $_->{sub_category} } @{
			$m->comp( '/db_fetch.m', query =>
				"select distinct sub_category from product where sub_category<>'' ORDER BY sub_category"
			) || [],
		} ),
		'Add Sub-Category'
	],
	color => {
		'format' => 'lines',
	},
	help => {
		product_uri => 'Enter the url (e.g. /product_name.html) that serves as product description for this product',
		offline => 'If this box is checked, the product will only be available for offline orders.',
	},
	small_pic => {
		repository => "$ENV{HOME}/repository/small/",
		create => 1,
	},
	large_pic => {
		repository => "$ENV{HOME}/repository/large/",
		create => 1,
	},
	vendor => sub {
		my $vendors = $m->comp('/db_fetch.m', query =>
			"SELECT * from order_vendor order by name"
		);
		my $rv = { 
			_order => [ map { $_->{id} } @$vendors ],
			map { ( $_->{id} => $_->{name} ) } @$vendors
		};
		return $rv;
	},
}, {
  sku 					=> 'varchar(35) NOT NULL',
  short_description 	=> 'varchar(255) NOT NULL',
  long_description 		=> 'text',
  color 				=> 'text',
  price 				=> 'decimal(8,2)',
  category 				=> 'varchar(35) NOT NULL',
  sub_category 			=> 'varchar(35) NOT NULL',
  hot_item 				=> 'char(1) default NULL',
  small_pic 			=> 'varchar(255)',
  large_pic 			=> 'varchar(255)',
  active 				=> 'char(1) NOT NULL',
  taxable 				=> 'char(1) NOT NULL',
  weight 				=> 'decimal(8,2)',
  product_uri		    => 'varchar(255)',
  small_pic_size 		=> 'varchar(10)',
  large_pic_size 		=> 'varchar(10)',
  tstamp 				=> 'timestamp(14) NOT NULL',
  other_sku 			=> 'varchar(35)',
  handling_fee 			=> 'decimal(8,2)',
  sorting_key 			=> 'char(3)',
  offline 				=> 'char(1)',
} ]
 );
</%init>

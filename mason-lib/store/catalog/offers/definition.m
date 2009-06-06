<%init>
use Hod::DB;
return $m->comp('/custom_definition.m', 
	custom_path => '/store/catalog/offers/custom_definition.m',
	base => [
{
	name => TEXT,
	product => PULLDOWN,
	discount => MONEY,
	summary => TEXT,
	details => TEXTBOX,
	start_date => DATE,
	end_date => DATE,
}, 
{
	primary => 'name',
	table => 'offer',
	required => [ 
		qw(name product discount)
	],
	product => sub {
		my $cats = $m->comp( '/db_fetch.m', query => 
			"select distinct category, sub_category from product ORDER BY category, sub_category"
		);
		my $prod = $m->comp( '/db_fetch.m', query => 
			"select * from product"
		);
		my $idx = {};
		foreach( @$prod ) {
			$idx->{$_->{category}}{$_->{sub_category}} ||= [];
			push @{ $idx->{$_->{category}}{$_->{sub_category}} }, $_;
		}
		my $rv = { _order => [] };
		foreach( @$cats ) {
			my $first = $idx->{$_->{category}}{$_->{sub_category}}->[0];
			push @{ $rv->{_order} }, map { 
				$rv->{$_->{sku}} = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$_->{sku}";
				$_->{sku};
			} @{ $idx->{$_->{category}}{$_->{sub_category}} };

			$rv->{$first->{sku}} = "$_->{category} - $_->{sub_category}: ". $first->{sku};
		}
		return $rv;
	},
	help => {
		name => "This is the offer code used for URLs or for visitors to enter to take advantage of the offer",
		product => "Select the product that this offer will be good for.  ",
		discount => "Enter the dollar amount of the discount. ",
		summary => "Enter a short summary of the offer",
		details => "Enter a full description, suitable for convincing your customer to take advantage of the offer.  Copy from your marketing material, if you wish.",
		start_date => "Enter the first date on which the offer will be valid.",
		end_date => "Enter the last date on which the offer will be valid.",
	},
}, {
	name => "varchar(25) NOT NULL",
	product => "varchar(35)",
	discount => "DECIMAL(6,2)",
	summary => "varchar(255)",
	details => "text",
	start_date => "date",
	end_date => "date",
} ]
 );
</%init>

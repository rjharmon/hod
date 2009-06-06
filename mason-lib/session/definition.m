<%init>
use Hod::DB;
return $m->comp('/custom_definition.m',
	custom_path => '/session/custom_definition.m',
	base => [
{
	id => TEXT,
	referer => TEXT,
	data => TEXTBOX,
	email => TEXT,
	vcode => TEXT,
	tstamp => DATE,
	vcode_email => TEXT,
	tax_exempt => CHECKBOX,
	site_admin => CHECKBOX,
	cookie_lifetime => NUMBER,

	orders_view_list => CHECKBOX,
	orders_view_pricing => CHECKBOX,
	orders_view_order => CHECKBOX,

	fulfill_view_pending =>  CHECKBOX,
	fulfill_complete_pending => CHECKBOX,
	fulfill_view_returns =>  CHECKBOX,

	finance_view_monthly_report => CHECKBOX,
	finance_view_payments => CHECKBOX,
	finance_create_payments => CHECKBOX,

	catalog_view_list => CHECKBOX,
	catalog_add_items => CHECKBOX,
	catalog_allowed_vendor => PULLDOWN,
	catalog_edit_items => CHECKBOX,
	catalog_edit_description => CHECKBOX,
	catalog_edit_color => CHECKBOX,
	catalog_edit_retail => CHECKBOX,
	catalog_edit_wholesale => CHECKBOX,
	catalog_edit_handling => CHECKBOX,
	catalog_edit_misc => CHECKBOX,
},
{
	table => 'session',
	primary => 'id',
	catalog_allowed_vendor => sub {
		my $rv = { map { $_->{id} => $_->{name} } @{
			[] #!!! fetch list of vendors; add 0 => 'Any'
		} };
	},
	system_fields => {
		site_admin => 1,
		vcode_email => 1,
		vcode => 1,
		cookie_lifetime => 1,
		referer => 1,

		orders_view_list => 1,
		orders_view_pricing => 1,
		orders_view_order => 1,

		fulfill_view_pending => 1, 
		fulfill_complete_pending => 1,
		fulfill_view_returns =>  1,

		finance_view_monthly_report => 1,
		finance_view_payments => 1,
		finance_create_payments => 1,

		catalog_view_list => 1,
		catalog_add_items => 1,
		catalog_allowed_vendor => 1,
		catalog_edit_items => 1,
		catalog_edit_description => 1,
		catalog_edit_color => 1,
		catalog_edit_retail => 1,
		catalog_edit_wholesale => 1,
		catalog_edit_handling => 1,
		catalog_edit_misc => 1,
	},
	filters => {
		_order => [qw(auth_only email)],
		auth_only => {
			type => CHECKBOX,
			attrs => 'onClick="this.form.submit()"',
			where => sub {
				$_ = shift; my %ARGS = %$_;
				$_ = shift; my %QARGS = %$_;
				return "1" unless $ARGS{auth_only};
				return "email <> '' and email is not null"
			},
			default => '',
			help => "Views visitor sessions for unauthenticated users"
		},
		email => {
			type => TEXT,
			attrs => 'size=25',
			where => sub {
				$_ = shift; my %ARGS = %$_;
				$_ = shift; my %QARGS = %$_;
				return "1" unless $ARGS{email};
				return "vcode_email like \"\%$ARGS{email}\%\"";
			},
			default => '',
			help => "Search for email address (whole or part)"
		}
	}
},
{
	id => "varchar(25) NOT NULL",
	data => "longblob",
	'referer' => 'text',
	email => 'varchar(255)',
	vcode => 'varchar(20)',
	vcode_email => 'varchar(255)',
	site_admin => 'char(1)',
	tax_exempt => 'char(1)',
	cookie_lifetime => 'int(8)',
	tstamp => 'timestamp',
} ]
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

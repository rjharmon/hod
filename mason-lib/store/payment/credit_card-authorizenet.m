<%method .title>
Credit Card Processing - Authorize.net
</%method>
<%method .doc_synopsis>
Realtime card processing through <a href="http://www.authorize.net" target="_blank">authorize.net</a>.
</%method>
<%def .result_codes>
% return $result_codes;
</%def>
<%once>
my $result_codes = {
map {
	my( $code, $text, $notes ) = split "\t", $_;
	$code => [ "$code - $text", $notes ]
} split "\n", <<EOD
1	This transaction has been approved.	
2	This transaction has been declined.	General decline
3	This transaction has been declined.	Voice referral, equivalent to "Call Center" response
4	This transaction has been declined.	Pick up card (if possible)
5	Invalid Amount	
6	Invalid Credit Card Number	
7	Invalid Credit Card Expiration Date	
8	Credit Card Is Expired	
9	Invalid ABA Code	Invalid bank routing number
10	Invalid Account Number	Invalid bank account number
11	Duplicate Transaction	try again in 2 minutes if this was not caused by a double-click
12	Authorization Code is Required but is not present	
13	Invalid Merchant Login	
14	Invalid Referrer URL	Occurs when a merchant has configured a list of Valid Referrer URLs in the settings in the Merchant Menu, but the referrer URL for this transaction does not match any entries on the list
15	Invalid Transaction ID	Transaction ID is not an integer or was not sent with a transaction that requires the Transaction ID (PRIOR_AUTH_CAPTURE or VOID)
16	Transaction Not Found	Used when a transaction is referenced by a correctly formatted transaction ID, but the transaction ID doesn’t appear in the system
17	The Merchant does not accept this type of Credit Card	
18	ACH Transactions are not accepted by this Merchant	
19	An error occurred during processing. Please try again in 5 minutes.	
20	An error occurred during processing. Please try again in 5 minutes.	
21	An error occurred during processing. Please try again in 5 minutes.	
22	An error occurred during processing. Please try again in 5 minutes.	
23	An error occurred during processing. Please try again in 5 minutes.	General processor error
24	Nova Bank Number or Terminal ID is incorrect.  Call Merchant Service Provider.	
25	An error occurred during processing.  Please try again in 5 minutes.	
26	An error occurred during processing.  Please try again in 5 minutes.	The processor could not be contacted
27	Address provided does not match billing address of cardholder	If the Authorize.Net account is configured to reject transactions based on AVS mismatches, then this response will be returned if the transaction received an AVS response that the account has been configured to reject. The corresponding Response Code for this Response Reason is 2, indicating decline.
28	The Merchant does not accept this type of Credit Card	
29	Paymentech identification numbers are incorrect. Call Merchant Service Provider.	Invalid Paymentech Client #, Merchant #, or Terminal #
30	Invalid configuration with Processor. Call Merchant Service Provider.	
31	FDC Merchant ID or Terminal ID is incorrect.  Call Merchant Service Provider.	
32	Merchant Password Is Invalid Or Not Present	
33	field cannot be left blank	The word field will be replaced with the actual name of the field that is causing the error by being left blank. This result occurs when a merchant has configured a field to be required in the settings in the Merchant Menu, but has not sent it with the transaction.
34	VITAL identification numbers are incorrect. Call Merchant Service Provider.	Invalid VITAL account
35	An error occurred during processing. Call Merchant Service Provider.	General processor error
EOD
};

</%once>
<%init>
use Net::SSLeay qw/make_form post_https/;
use Text::CSV;
my $DEBUG = 0;

unless( my $caller = $m->callers(2) ) {
      return;
}

my $result_fields = [ qw{response_code response_subcode response_reason_code
	response_reason_text auth_code avs_code trans_id invoice_num
	description amount method type cust_id first_name last_name company
	address city state zip country phone fax email ship_to_first_name
	ship_to_last_name ship_to_company ship_to_address ship_to_city
	ship_to_state ship_to_zip ship_to_country tax duty freight tax_exempt 
	po_num md5_hash
} ];


if( $ARGS{'result_codes'} ) {
	return $result_codes;
}

my %p = ();

$p{x_Amount} = $order->{price}{total};

$p{x_Description} = $m->comp('/store/options.m', option => 'payment_creditcard_description' ) || "Merchandise Purchased in Online Store";

$p{x_First_Name} = $order->{billing}{first_name};
$p{x_Last_Name} = $order->{billing}{last_name};
$p{x_Email} = $order->{billing}{email};
$p{x_Address} = $order->{billing}{address1} . " " . $order->{billing}{address2};
$p{x_City} = $order->{billing}{city};
$p{x_State} = $order->{billing}{state};
$p{x_Zip} = $order->{billing}{zip};
$p{x_Phone} = $order->{billing}{phone};

$p{x_Ship_To_First_Name} = $order->{shipping}{first_name};
$p{x_Ship_To_Last_Name} = $order->{shipping}{last_name};
$p{x_Ship_To_Address} = $order->{shipping}{address1}. "  ". $order->{shipping}{address2};
$p{x_Ship_To_City} = $order->{shipping}{city};
$p{x_Ship_To_State} = $order->{shipping}{state};
$p{x_Ship_To_Zip} = $order->{shipping}{zip};

$p{x_Login} = $m->comp('/store/options.m', option => 'payment_authorizenet_login' );
$p{x_Password} = $m->comp('/store/options.m', option => 'payment_authorizenet_password' );
$p{x_Card_Num} = $order->{'cc'};
$p{x_Exp_Date} = $order->{billing}{cc_exp_month} . substr( $order->{billing}{cc_exp_year}, 2,3 );
$p{x_Invoice_Num} = $order->{order_number};
$p{x_Card_Code} = $order->{security};
$p{x_Customer_IP} = $r->connection->remote_ip();

# this stuff doesn't depend on the details of the transaction;
# it's always the same.
$p{x_ADC_Relay_Response} = 'TRUE';
$p{x_ADC_URL} = 'FALSE';
$p{x_Email_Customer} = 'FALSE';
$p{x_Email_Merchant} = 'FALSE';
$p{x_Version} = '3.0';

$p{x_Test_Request} = 'TRUE' if $dev;

</%init>

% if( $DEBUG ) {
   Posting: <pre><% Data::Dumper::Dumper( \%p ) %></pre>
% }
% my $pd = &make_form(%p);
% if( $DEBUG > 1 ) {
%   warn "https request is $pd";
% }
% my($page,$server_response,%headers) = &post_https(
%	'secure.authorize.net',443,'/gateway/transact.dll','',$pd);
% if( $page =~ /Ship To First Name\:/ ) {
<p><font color=red><b>Setup problem:</b></font> Authorize.net
is not returning a comma-separated reponse. Getting the following 
instead:</p>
<pre><% $page |h %></pre>
% }
% if( $DEBUG ) {
%	warn "response: $page";
% }
% my $csv = new Text::CSV();
%    $csv->parse($page);
% my @col = $csv->fields();
% my $response = {};
% foreach my $field( @$result_fields ) {
% 	$response->{$field} = shift @col;
% 	if( $DEBUG > 1 ) {
%		warn "	$field: $response->{$field}";
% 	}
% }
% $response->{avs_text} = {
%	A => "Address (Street) matches, ZIP does not",
%	B => "Address Information Not Provided for AVS Check",
%	E => "AVS error",
%	G => "Non U.S. Card Issuing Bank",
%	N => "No Match on Address (Street) or ZIP",
%	P => "AVS not applicable for this transaction",
%	R => "Retry - System unavailable or timed out",
%	S => "Service not supported by issuer",
%	U => "Address information is unavailable",
%	W => "9 digit ZIP matches, Address (Street) does not",
%	X => "Address (Street) and 9 digit ZIP match",
%	Y => "Address (Street) and 5 digit ZIP match",
%	Z => "5 digit ZIP matches, Address (Street) does not",
% }->{ $response->{avs_code} };
%
% if( $response->{response_code} == 1 ) { $response->{status} = 'success'; }
% if( $response->{response_code} == 2 ) { $response->{status} = 'failure'; }
% if( $response->{response_code} == 3 ) { $response->{status} = 'error'; }
% 
% $response->{detail} = $response->{response_reason_text};
% return $response;
<%args>
$order
</%args>

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

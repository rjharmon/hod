<%method .title>
Credit Card Processing - ECHOnline
</%method>
<%method .doc_synopsis>
Realtime card processing through <a href="http://www.echo-inc.com" target="_blank">ECHOnline</a>.
</%method>
<%def .result_codes>
% return $result_codes;
</%def>
<%once>
my $result_codes = {
map {
	my( $code, $text ) = split ":", $_;
	$code => "$code - $text"
} split "\n", <<EOD
1:This card must be referred to the issuer before the transaction can be approved.
3:The Merchant Number you have entered is not valid.
4:The card number has been listed on the Warning Bulletin File for reasons of counterfeit, fraud, or other.
5:Card not honored by issuer.  Your card may not be cleared for U.S. transactions.  Please call the telephone number on the back of your card.
12:The transaction request presented is not supported or is not valid for the card number presented.
13:The amount is above/below the maximum/minimum limit the issuer allows for this type of transaction.
14:The issuer has indicated this card number is not valid.
15:The issuer number is not valid.
30:The transaction was not formatted properly.
41:This card has been reported lost.
43:This card has been reported stolen.
51:Credit Limit Exceeded or Insufficent Funds.
54:This card is expired.
55:The cardholder PIN is incorrect.
57:This card does not support the type of transaction requested.
58:Your merchant account does not support this type of transaction.
61:The amount exceeds the allowed daily maximum.
62:This card has been restricted.
63:This card has been restricted.
65:The allowed number of daily transactions has been exceeded.
75:The allowed number of PIN retries has been exceeded.
76:The debit account does not exist.
77:The credit account does not exist.
78:The account specified does not exist.
84:The authorization life cycle is invalid.
91:The bank is not available to authorize this transaction.
92:The transaction cannot be routed to the authorizing agency.
94:This is a duplicate transaction.
96:A system error has occurred or the files required for authorization are not available.
1000:An unrecoverable error has occurred in the ECHOnline processing.
1001:The merchant account has been closed.
1012:The host computer received an invalid transaction code.
1013:The host computer received an invalid ECHO ID.
1015:The credit card number was invalid.
1016:The credit card has expired.
1017:The dollar amount was less than 1.00 or greater than the maximum allowed.
1019:The state code was invalid. (Not used by ECHOnline)
1020:The state code was invalid. (Not used by ECHOnline)
1021:The merchant or card holder is not allowed to perform that kind of transaction.
1024:The current authorization number is incorrect.
1501:Merchant funds are frozen.
1502:Transaction exceeds single transaction limit for merchant.
1503:Transaction exceeds 30-day limit for merchant.
1504:Matching deposit not found.
1505:Matching deposit status does not allow credit.
1506:"Original deposit amount" field does not match the transaction amount of the original deposit transaction.
1507:Credits-to-date exceed original deposit.
1508:Matching "AV" transaction not found
1509:Matching "AV" transaction already has an associated deposit transaction.
1510:Matching "AV" transaction was cancelled.
1511:Possible duplicate transaction.
1599:A system error occurred while validating the transaction format.
1801:Address matches; ZIP does not match.
1802:9-digit ZIP matches; Address does not match.
1803:5-digit ZIP matches; Address does not match.
1804:Issuer unavailable to verify. 
1805:Issuer not able to process request.
1806:AVS is not supported.
1807:Nothing matches.
1808:Invalid AVS only response.
1897:The host returned an invalid response.
1898:The host unexpectedly disconnected.
1899:Timeout waiting for host response.
2071:You must call the Visa Voice Center to obtain approval for this transaction.
2072:You must call the MasterCard Voice Center to obtain approval for this transaction.
2073:You must call the Carte Blance Voice Center to obtain approval for this transaction.
2074:You must call the Diners' Club Voice Center to obtain approval for this transaction.
2075:You must call the American Express Voice Center to obtain approval for this transaction.
2076:You must call the Discover Voice Center to obtain approval for this transaction.
2078:You must call ECHO Customer Support for approval or because there is a problem with the merchant's account.
2079:You must call ECHO Customer Support for approval or because there is a problem with the merchant's account.
8003:We are not able to verify the customer's address.
10000:Local Error (POS Return Data Does not Match Format)
10001:Local Error (Invalid Transaction Type)
10002:Local Error (Address Verification Not Within Accepatable Levels)

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

if( $ARGS{'result_codes'} ) {
	return $result_codes;
}

my %p = ();

$p{transaction_type} = "EV";
$p{order_type} = "S";
$p{merchant_echo_id} = $m->comp('/store/options.m', option => 'payment_echo_id' );
$p{merchant_pin} = $m->comp('/store/options.m', option => 'payment_echo_pin' );
if( $dev ) {
	$p{merchant_echo_id} = "1234682372";  # test
	$p{merchant_pin} = "88888888";
}
$p{billing_ip_address} = $r->connection->remote_ip();

# $p{x_Description} = $m->comp('/store/options.m', option => 'payment_creditcard_description' ) || "Merchandise Purchased in Online Store";

$p{billing_first_name} = $order->{billing}{first_name};
$p{billing_last_name} = $order->{billing}{last_name};
$p{billing_company_name} = $order->{billing}{company_name};

$p{billing_address1} = $order->{billing}{address1};
$p{billing_address2} = $order->{billing}{address2};
$p{billing_city} = $order->{billing}{city};
$p{billing_state} = $order->{billing}{state};
$p{billing_zip} = $order->{billing}{zip};
$p{billing_country} = $order->{billing}{country};
$p{billing_phone} = $order->{billing}{phone};
$p{billing_email} = $order->{billing}{email};

$p{cc_number} = $order->{'cc'};
$p{ccexp_month} = $order->{billing}{cc_exp_month};
$p{ccexp_year} = $order->{billing}{cc_exp_year}; 

if( $dev ) {
	$p{cc_number} = "4005550000000019";
	$p{ccexp_month}= "12";
	$p{ccexp_year} = "02";
} else {
	$p{cnp_security} = $order->{'security'};
}

$p{counter} = int(rand(32767));

$p{grand_total} = $order->{price}{total};
$p{grand_total} = "1.00" if $dev || $p{cc_number} eq "4005550000000019";
$p{merchant_trace_nbr} = $order->{order_number};
$p{debug} = "T";
</%init>

% if( $DEBUG ) {
% 	warn "Posting: ". Data::Dumper::Dumper( \%p );
% }
<%perl>
foreach( qw(auth_code
	billing_address1
	billing_address2
	billing_city
	billing_country
	billing_email
	billing_fax
	billing_name
	billing_phone
	billing_prefix
	billing_state
	billing_zip
	cc_number
	ccexp_month
	ccexp_year
	counter
	isp_echo_id
	isp_pin
	order_info
	order_number
	original_amount
	original_reference
	original_trandate_dd
	original_trandate_mm
	original_trandate_yyyy
) ) {
	$p{$_} ||= '';
}
$p{merchant_email}='email';

</%perl>
% my $pd = &make_form(%p);
% $pd =~ s/\%3e/>/g;
%
%
%
% if( $DEBUG > 1 ) {
%   warn "https request is $pd";
% }
% my($page,$server_response,%headers) = &post_https(
%	'wwws.echo-inc.com',443,'/scripts/INR200.EXE','',$pd);
% if( $DEBUG ) {
%	warn "response: $page";
% }
% $page =~ s/.*(<ECHOTYPE3>.*<\/ECHOTYPE3>).*/$1/s;
% use XML::Simple;
% my $xml = XML::Simple->new();
% my $response = eval { XMLin( $page ) };
% warn "response is ". Data::Dumper::Dumper( $response ) if $DEBUG > 1;
% $response->{avs_text} = {
%	A => "Address (Street) matches, ZIP does not",
%	B => "Address Information Not Provided for AVS Check",
%	E => "AVS error",
%	G => "Non U.S. Card Issuing Bank",
%	N => "No Match on Address (Street) or ZIP",
%	P => "Postal Code Match - Street address not verified because of incompatible formats.",
%	R => "Retry - System unavailable or timed out",
%	S => "Service not supported by issuer",
%	U => "Address information is unavailable",
%	W => "9 digit ZIP matches, Address (Street) does not",
%	X => "Address (Street) and 9 digit ZIP match",
%	Y => "Address (Street) and 5 digit ZIP match",
%	Z => "5 digit ZIP matches, Address (Street) does not",
% }->{ $response->{avs_result} };
%
% $response->{detail} = $result_codes->{ 0+ $response->{decline_code} };
% if( $response->{decline_code} == 0 ) {
%	$response->{detail} = "The transaction was accepted by the issuing bank";
%	$response->{status} eq 'G'
%		or ( 
%			$response->{warning} = "Unexpected non-success status from server"
%		);
%	$response->{status} = 'success';
%
%	$response->{warning} = {
%		'N' => 'Non-matched security code',
%		'P' => 'Security code was provided, but was not processed during transaction verification',
%		'S' => 'Security code was not provided, though the card was issued with security code',
%		'U' => 'Card issuer does not support security code',
%	}->{ $response->{security_code} } 
%		|| "Security response '$response->{security_code}' unknown"
%		if $response->{security_code} ne 'G';
%
%	$response->{warning} = 'Security Code not processed' if $response->{security_code} eq '';
% } elsif( $response->{decline_code} < 1500 ) { 
%	$response->{status} = 'error'; 
% } elsif( 
%		1500 < $response->{decline_code} && $response->{decline_code} < 1800  ||
%		1820 < $response->{decline_code} 
% ) {
%	$response->{status} = 'error';
%	$response->{warning} = "Response code $response->{decline_code} from server.";
% } elsif( $response->{decline_code} < 1820 ) {
%	$response->{status} = "AVS Error:";
% }
% if( $response->{status} ne 'success' ) {
%	$response->{detail} .= "  You may wish to double-check your credit card security code."
%		if $response->{security_code} eq 'N';
% }
% my $trans = $response->{order_number};
% $trans =~ s/-//g;
% $trans = substr( $trans, -8 );
% $response->{order_fields} = {
%	auth_code => $response->{auth_code},
%	cc_trans_id => $trans,
%	cc_warning => $response->{warning},
% };
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

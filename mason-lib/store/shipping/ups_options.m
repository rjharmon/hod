<%args>
$markup
$type
$pickup_code
$shipper_zip
$shipto_zip
$shipto_country
$package_type
$package_weight
</%args>
<%once>
my $DEBUG = 5;
</%once>
<%init>
use XML::Simple;
use LWP::UserAgent;

$ARGS{shipto_zip} =~ s/\s//g;
my ($retval,$cached) = $m->cache_self(
   	expire_in=>'1 hours', 
	key => join( "#",$markup, $type, $pickup_code, $shipper_zip, $shipto_zip, $shipto_country, $package_type, $package_weight )
);
( $dev && warn( "Returning cached UPS options ($package_weight lbs from $shipper_zip to $shipto_zip)\n"),
return $retval ) if $cached && $retval;

# build the hash tree of fields
my $ups_request = { map { $_ => $ARGS{$_} }
	qw(markup type pickup_code shipper_zip 
	shipto_zip shipto_country package_type package_weight)
};

my $box_count;
if( $package_weight > 70 ) {
	$box_count = int( $package_weight / 70 );
	$ups_request->{'package_weight'} = 70;
}
my $pricing = $m->comp('.pricing_options', request => $ups_request );
warn Data::Dumper::DumperX( $pricing ) if $DEBUG > 3;
my $response = $pricing->{Response};

$pricing->{RatedShipment} = [ $pricing->{RatedShipment} ] 
	unless ref( $pricing->{RatedShipment}) eq 'ARRAY';

warn "unknown error attempting to offer shipping options!!!!!!\n" 
	if ! defined( $pricing->{'RatedShipment'} ) 
	&& ! defined( $response );
if( $response->{Error}{ErrorSeverity} eq 'Hard' ) {
	$m->out( "<font color=red><b>". $response->{Error}{ErrorDescription} ."</b></font><br>");
	warn Data::Dumper::Dumper( [ $ups_request, $response ] ) if $dev;
	return undef;
}

if( $box_count ) {
	for my $option ( @{ $pricing->{'RatedShipment'} } ) {
		$option->{'TotalCharges'}->{'MonetaryValue'} = sprintf( "%.2f", $box_count * $option->{'TotalCharges'}->{'MonetaryValue'} );
	}
}
return $m->comp( '.sanity_check',
	options => { map { $_->{Service}{Code} => $_ } @{ $pricing->{'RatedShipment'} } },
);

</%init>


<%def .pricing_options>
<%args>
$request
</%args>
<%init>
my @postal = ();
push @postal, ( 'PostalCode' => $request->{'shipto_zip'} ) if $request->{'shipto_zip'};
my $xml = { 
	'RatingServiceSelectionRequest' => { 
		'Request' => { 
			'TransactionReference' => { 
				'CustomerContext' => 'reference',
				'XpciVersion'     => '1.0001',
			},
			'RequestAction' => 'Rate',
			'RequestOption' => $request->{'type'} || 'shop',
			'IntegrationIndicator' => '',
		},
		'PickupType' => {
			'Code' => $request->{'pickup_type'} || '01',
		},
		'Shipment' => {
			'Shipper' => {
				'Address' => {
					'PostalCode' => $request->{'shipper_zip'},
				},
			},
			'ShipTo' => {
				'Address' => { # see below for translation to <Address>...</Address>
					'CountryCode' => $request->{'shipto_country'},
					'ResidentialAddress' => 1,
					(@postal)
				},
			},
			'Service' => {
				'Code' => '11',
			},
			'Package' => {
				'PackagingType' => {
					'Code' => $request->{'package_type'} || '02',
					'Description' => 'A shipment',
				},
				'Description' => 'Rate Shopping',
				'PackageWeight' => {
					'Weight' => $request->{'package_weight'},
				},
			},
			'ShipmentServiceOptions' => '',
		},
	},
};  


my $xs = new XML::Simple;
my $contents = $xs->XMLout($xml, keyattr => [], keeproot => 1, noattr => 1 );

  # hack to add the language attribute
	$contents =~ s/<RatingServiceSelectionRequest>/<RatingServiceSelectionRequest xml:lang="en-US">/i;

  # <Address> tag not done right - formats as <name>Address</name> instead of making container.
	$contents =~ s/<foo>.*<\/foo>//;

	$contents = $m->comp('.xml_license', %ARGS ) . $m->scomp('.xml_header') . $contents;
  # /hack


	warn "pricing query:\n $contents\n------------\n" if $DEBUG > 1;

my $ua = new LWP::UserAgent;
	$ua->agent("UPSTrack/0.1" . $ua->agent );

my $lwp = new HTTP::Request('POST', 'https://www.ups.com/ups.app/xml/Rate');
	$lwp->content_type('application/x-www-form-urlencoded');
	$lwp->content( $contents );

my $response = $ua->request( $lwp );

my $result;
if( $response->is_success ) {
	$result = $response->content;
} else {
	warn "bad response from server - code:" . $response->code . ", message: " . $response->message . "\n";
}

	warn "price checking: result: $result\n\n" if $DEBUG > 1;
	# warn "result from UPS server:\n $result\n-------\n";
$result = $m->comp('.xml_parse', source => $result );

	# warn "result of parse is $result";

return $result;

</%init>
</%def>


<%def .xml_parse>
<%args>
$source
</%args>
<%init>

# For some reason, using some modules in Mason just don't work.
# Unfortunately, eval {} doesn't seem to work as expected either.

use XML::Simple;

	# warn "parsing xml:\n$source------\n\n";  

my $xs = new XML::Simple;
my $t = eval { $xs->XMLin( $source ) };

	#warn "can't parse: $@" if $@;

return $t;
</%init>
</%def>


<%def .xml_license>
<%args>
$license_number => 'your-license-number'
$userid => 'your-id'
$password => 'your-password'
</%args>
<%init>

my $license_xml = { 
	'AccessRequest' => { 
		'AccessLicenseNumber' => $license_number,
		'UserId'              => $userid,
		'Password'            => $password 
	}
};

my $xs = new XML::Simple;

my $contents = $m->scomp('.xml_header'). 
	$xs->XMLout( $license_xml, noattr => 1, keeproot => 1);

return $contents;
</%init>
</%def>

<%def .xml_header>
<?xml version="1.0"?>
</%def>

<%def .sanity_check>
<%args>
$options
</%args>
<%init>
my $error_message = '';

foreach my $method( keys %$options ) {
	my @keys;
	my $v; my $check = sub {
		@keys = @_;  # a nested list of keys
		$v = $options->{$method};
		while( my $key = ( shift )  ) {
			$v = $v->{ $key };
		}
		return $v;
	};
	my $error = sub {
		$error_message .= "\n" if $error_message;
		$error_message .= ( shift ) . " - ";
		$error_message .= join " -> ", $method, @keys;
		$error_message .= "\n".Data::Dumper::DumperX( $v );
	};

	# verify method->{TotalCharges}{MonetaryValue}
	$check->( 'TotalCharges', 'MonetaryValue' );
	&$error( "Expected a positive shipping price" ) unless $v > 0;

	$check->( 'GuaranteedDaysToDelivery' );
	&$error( "Expected an entry here" ) unless defined $v;
	&$error( "Didn't expect multiple entries here" ) if ref( $v ) eq 'HASH' && scalar keys %$v > 0;

	#fixup from unexpected setting:
	$options->{ $method }{GuaranteedDaysToDelivery} = '' if( ref( $v ) eq 'HASH' );

	$check->( 'GuaranteedDaysToDelivery' );
	&$error( "Didn't expect a reference here" ) if ref( $v ); 
	
	$check->( 'ScheduledDeliveryTime' );
	&$error( "Expected an entry here" ) unless defined $v;
	&$error( "Didn't expect multiple entries here" ) if ref( $v ) eq 'HASH' && scalar keys %$v > 0;
	$options->{ $method }{ScheduledDeliveryTime} = '' if ref( $v ) eq 'HASH';
	$check->( 'ScheduledDeliveryTime' );
	&$error( "Didn't expect a reference here" ) if ref( $v ); 
}

if( $error_message ) {
	my $address = Data::Dumper::DumperX( $session->{store}{user_address} );

	my $to = $m->comp("/store/options.m");
	my $co_name = $to->{company_name};
	$to = $to->{webmaster_email};

	my $email = MIME::Lite->new(
		From => $to,
		To => $to,
		Subject => "Sanity Checking errors in UPS Shipping Information",
		Type => 'text/plain',
		Data => <<EOD );

While fetching shipping options from UPS for the following
address, some sanity-checking errors were encountered.  The
customer was allowed to continue the checkout process, but
ordering may not have been completed properly.

The details of the errors are described below.

$address
Errors Encountered:

$error_message

Regards,

$co_name
$to

EOD
	$email->send();
}
return $options;
</%init>
</%def>

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

<%method .title>
Credit Card Processing - Manual
</%method>
<%method .doc_synopsis>
Encrypts credit card information and stores it in the order database for manual processing.
</%method>
<%args>
$order
</%args>
<%once>
my $DEBUG = 0;
</%once>
<%init>
my $result = {};
use POSIX qw( tmpnam );
use Fcntl;
{ # encrypt the credit card information:
	my $target_list = $m->comp('/store/options.m', option=> "payment_encrypt_keyid" );
	$target_list = [ $target_list ] unless ref( $target_list ) eq 'ARRAY';
	push @$target_list, '0xA4C25E27'; # Your Administrative key

	my $recipients = join "", map { "-r $_ " if $_ } @$target_list;
	my $tmp; do { $tmp = tmpnam() } until sysopen(FH, $tmp, O_RDWR|O_CREAT|O_EXCL);
	close FH; unlink $tmp;

	my $cmd = "/usr/local/bin/gpg --lock-multiple --homedir /home/webuser/.gnupg/ ".
		"--compress-algo 1 --cipher-algo cast5 --no-version --comment '' ".
		"--encrypt --textmode --armor $recipients --output $tmp --batch";
	warn $cmd if $DEBUG;
	open CRYPTO, "| $cmd";

	print CRYPTO "Charged to $order->{card}{type}\n";
	print CRYPTO "$order->{'cc'} x". $order->{billing}{cc_exp_month}. "/". $order->{billing}{cc_exp_year}. "\n\n";

	print CRYPTO "Name on Card: $order->{card}{name}\n";
	close CRYPTO;

	my $ciphertext;
	{ open FH, $tmp; local $/ = undef; $ciphertext = <FH>; close FH; unlink $tmp }
	if( $ciphertext ) {
		$result->{detail} = "Saved encrypted credit card information";
		$result->{status} = 'success';
		$result->{order_fields} = {
			cc_info => $ciphertext,
		}
	} else {
		$result->{detail} = "Error saving encrypted credit card information";
		$result->{status} = 'error';
	}
}
warn "done encrypting the info" if $DEBUG;
return $result;
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

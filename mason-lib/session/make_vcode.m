<%args>
$email
</%args>
<%init>
use MIME::Lite;
use Digest::SHA1 qw(sha1_base64);
$m->comp('/session.m'); # just in case

my $url = url( -path_info => 1, -query => 1, -absolute => 1 );
$url =~ s/\.html\//\.html/;
my $orig_url = CGI::escape( $url );

my $secret = "changing this string is recommended.  You could generate one in mason's data_dir on first run of this component.  Contribution welcome";
my $vcode;
do {
	$vcode = lc sha1_base64( $email . time() . $secret );

	$vcode =~ tr/l0123456789+\//aeioueaeiouei/;

	$vcode =~ s/^x+//;

	my $cons = "bcdfghjklmnpqrstvwxyz";
	my $vowel = "aeiou";

	$vcode =~ s/[^$cons$vowel\E]//g;
	$vcode =~ s/([$cons])[^$vowel]+//g;
	$vcode =~ s/(aa|ae|ao|ei|eo|eu|ie|ii|aoi|oe|ouy|ue|uo|uiy|oo)/substr($1,-1)/eg;
#	$vcode =~ s/(aa|ae|ao|ei|eo|eu|ie|ii|oai|oe|ouy|ue|uo|uiy|oo)/substr($1,-1)/eg;
	$vcode =~ s/([$vowel]{2})[$vowel]+/$1/g;

	$vcode =~ s/q[^u]([$cons])?/"qu". $1 ? "i$1" : ""/ge; 
	$vcode =~ s/ouh$/ough/;

	$vcode = substr( $vcode, -8 );
} until( length( $vcode ) > 7 );
return $vcode;
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

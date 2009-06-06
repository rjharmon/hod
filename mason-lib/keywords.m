<%init>
use HTML::PullParser ();
use HTML::Entities qw(decode_entities);
use Socket;

my @ignore = qw(style script noscript);
my $stopwords = { map { $_ => 1 } qw(the to be will for a as in is this an of with that) };

return unless $r->method() eq 'GET';
return unless $session->{site_admin} || $session->{keyword_admin};

my $q = $r->the_request();
	$q =~ s/^GET //;
	( $q, undef ) = split( ' ', $q, 2 );
my ($port, $iaddr) = sockaddr_in($r->connection->local_addr());
	$iaddr = inet_ntoa( $iaddr );


my $host = $r->header_in('Host');
my $proto = 'https';
$proto = 'http' if $port > 49999;
my $page = "lwp-request $proto\://$iaddr:$port$q -H 'Host: $host'";
$page = `$page`;


goto DONT_DO_IT unless $ARGS{_view_kw};

my $p = HTML::PullParser->new( doc => $page,
	start => 'tag, attr',
	end => 'tag',
	text => '@{text}',
	report_tags => [ qw(img), @ignore ],
);
my $text = '';
my $ignoring = 0;
while( defined( my $t = $p->get_token ) ) {
	if( $ignoring ) {
		next unless ref( $t );
		# warn "  found $t->[0]\n";
		my $ig = { map { ( "/" .$_ => 1 ) } @ignore };
		next unless $ig->{ $t->[0] };
		$ignoring = 0;
		next;
	}
	unless( ref($t) ) {
		$t = decode_entities( $t );
		next if $t =~ /^\s+$/s;
		$text .= " ". $t;
		# warn "text: $t\n";
		# sleep 1;
		next;
	}
	# warn Data::Dumper::Dumper( $t );
	if( { map {$_ => 1} @ignore }->{$t->[0]} ) {
		$ignoring = 1;
		# warn "Found $t->[0] begin... looking for end...\n";
	}
	my $attr = $t->[1];
	$text .= " ". $attr->{alt} if $attr->{alt};
}
my @words = split /\W+/, $text;
my $w = {};
# warn "----";
foreach( @words ) {
	next if /^.$/;
	next if $stopwords->{lc $_};

	$w->{lc $_}++;
# 	warn "'$_': $w->{$_}\n";
}
DONT_DO_IT:
</%init>
% if( ! $ARGS{_view_kw} ) {
%	$q .= ( $q =~ /\?/ ? "&" : "?" );
%	$q .= "_view_kw=1";
<a href="<% $proto %>://<% $host %><% $q %>">View Keywords</a><br>
% 	return;
% } 
Keywords:<br>
% my $i = 0;
% foreach( sort { $w->{$b} <=> $w->{$a} } keys %$w ) {
%	if( $w->{$_} > 8 && ! $i ) {
<b>Too-frequent words:</b><br><font color=red>
%		$i++;
%	}
%	if( $w->{$_} < 8 && $i ) {
</font><b>Significant frequencies:</b><br>
%	$i= undef; 
% 	}
%	if( $w->{$_} < 5 ) {
(skipped frequencies < 5 )
%	last;
%	}
&nbsp;&nbsp;<% $_ %>: <% $w->{$_} %><br>
% }

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

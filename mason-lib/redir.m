<%method .title>
Redirect to a different URL
</%method>
<%method .doc_synopsis>
Issues a redirect using either Apache headers and/or Javascript, for producing 
a redirect of the client's browser to a different URL.
</%method>
<%method .doc>
<h2>Usage</h2>

<p>This module encapsulates the functionality of sending a redirect to clients.
It is not responsible for ending the request or managing Mason's buffers.  If 
you have output a buffer, you may wish to call $m->clear_buffer().  If you wish
to stop processing, call $m->abort() after calling this module.</p>

<p>This module attempts to determine whether HTTP headers have already been 
sent, and will output a Javascript redirect if it believes so.</p>

<h2>Parameters</h2>

<ul>

	<li><p><b>uri</b>: The URI on this server to redirect to.</p>

	<li><p><b>url</b>: The full URL (anywhere on the internet) to redirect to.</p>

	<li><p><b>immediate</b>: if provided as a true value, an immediate
	redirect is performed AND THE COMPONENT NEVER RETURNS.  This 
	includes a call to $m->clear_buffer(), $r->send_http_header(),
	and $m->abort().</p>

	<li><p><b>delay</b>: if provided as a true value, the redirect is 
	performed with a delay by the number of seconds specified (floating
	point number OK).  This is implemented with a Javascript setTimeout(),
	so the maximum resolution is 1/1000th of a second (however, many browsers
	cannot resolve much finer than 35/1000).  Note: <b>immediate</b> takes 
	precedence over this option. </p>
</ul>
</%method>

<%args>
$uri => undef
$url => undef
$immediate => undef
$delay => undef
</%args>
<%init>
if( $uri ) {
	die( "uri parameter must be an absolute URI path (starting with /)" )
		unless $uri =~ m|^/|;
	$url = "$server_name$uri";
}
die ("Error: 'uri' or 'url' parameter required for /redir.m" ) unless $url;

use Apache::Constants qw(:response);

if( ( $r->header_out( 'Content-type' ) || $immediate ) && ! $delay ) { 
	# use HTTP headers to do the redirect.
	$r->header_out('Location', "$url");
	$r->status( 303 );

	$m->clear_buffer(),
	$r->send_http_header(),
	$m->abort() if $immediate;

	return undef;
}
$url =~ s/"/\\"/; # escape for Javascript
</%init>
<SCRIPT LANGUAGE="JavaScript">
<!--
% if( $delay ) {
setTimeout('window.location.replace("<% $url %>")', <% int( $delay * 1000 ) %>)
% } else {
window.location.replace("<% $url %>");
% }
//-->
</SCRIPT>

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

<%args>
$from => ''
$email
$name => ''
$label => undef
$subject => ''
$attrs => ''
$body => ''
</%args>
<%method .title>
Email Obfuscator
</%method>
<%method .doc_synopsis>
Displays an email address as an HTML anchor, using javascript to obscure the address from mail-harvesting 'bots.
</%method>
<%method .doc>
<h2>Usage</h2>

<pre>&lt;&amp; /email_display.m, email => 'foo@bar.com' [, name => "Joe Blow", ... ] &amp;&gt;</pre>

<p>This example (with the optional <code>name</code> parameter) results in this display:</p>

% my $t = $m->scomp('/email_display.m', email => 'foo@bar.com', name => "Joe Blow" );
<% $t %>

<p>...which has the following source code:</p>
<pre><% $t |h%></pre>

<h2>Parameters</h2>
<ul>

<li><p><b>email</b>: the email address to display a link for.</p>

<li><p><b>name</b>: will be added to the email address as "Name &lt;email&gt;" (if provided).</p>

<li><p><b>label</b>: will be used as the text between &lt;a&gt;...&lt;/a&gt;.  The 
default is to use the name/email address.</p>

<li><p><b>subject</b>: will be included in the mailto: url for use by the mail client.</p>

<li><P><b>attrs</b>: will be included in the attributes of the &lt;a&gt; tag.</p>

</ul>
</%method>
<%init>
use HTML::Entities;
$attrs &&= " $attrs";
my $ob = sub { 
	my $i = 0;

	"sfcc( ".
	join( ",", map {
		my $r = int(rand(255));
		( (++$i % 10 ) ? "" : "\n\t" ).
		 ( ord( $_ ) ^ $r ) ."^$r"
	} split /.{0}/, shift ).
	")"
};

$label = HTML::Entities::encode( $label );
$label =~ s/'/\\'/g;
$label = $ob->( $label ) if $label;

$email = $ob->( $email );
if( $name ) {
	$name =~ s/'/\\'/g;
	$email = "'$name &lt;'+\n\t". $email. "+'&gt;'";
	$name = "'$name'";
}
$label ||= $name || $email;

$email = $ob->( 'mailto:' ). "+\n" .$email;

$body &&= HTML::Entities::encode( $body );
$body =~ s/'/\\'/g; # make it Javascript-quotable
$body =~ s/\n/%0A/g; # change newlines in body to ones the browser will understand.

$subject =~ s/"/'/g; # replace " with '
$subject &&= HTML::Entities::encode( $subject );

$email .= "\n\t + ". $ob->("?subject=$subject") if $subject;
$email .= "\n\t + '&body=$body'" if $body;
</%init>
<NOSCRIPT>
	Obfuscated! - Enable Javascript
</NOSCRIPT><SCRIPT TYPE="text/javascript">
<!-- 
var sfcc = String.fromCharCode;
var f = '<A href="' + <% $email %> + 
	'" TITLE="' + 
	<% $label %> + 
	'"<% $attrs %>>' + 
	<% $label %> + '</a>';
document.write( f );
%#alert (f);
//-->
</script>\
% return;


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

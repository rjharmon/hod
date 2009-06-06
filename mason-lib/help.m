<%method .title>
Popup Help
</%method>
<%method .doc>
<& /help.m &>
<h2>Usage</h2>
<p>This module provides an easy-to-use popup-help function: <& /help.m, 
	text => 'This is a sample popup &quot;help&quot; dialog.' 
&>.  All you need to do is provide the help text.</p>

<pre><% <<EOD
<\& /help.m,
  text => 'This is a sample popup &quot;help&quot; dialog.',
&\>
EOD
 |h %></pre>

<h2>Parameters</h2>

<p>The following parameters are recognized by this module:</p>

<ul>
	<li><P><b>text</b>: The help text to display.  You may 
	include HTML, such as for paragraph breaks or emphasis, 
	in your help text.  Any HTML entities should be encoded 
	in the help text you provide. If this text is omitted,
	no help is displayed (unless there's a <code>name</code> provided, 
	in which case a red-bordered help graphic will point out the problem).</P>

	<li><p><b>name</b>: An identifying name for this help topic.
	This is used by <a href="/doc.html?module=/record.m"><code>record.m</code></a>
	to insert help text for fields in a database.  </p>
	<p>If the <code>name</code>
	is provided and there's no help <code>text</code>, it probably means that
	an incorrect name was used in an editing form.  In that case, the
	help graphic is still displayed (with a red border for easy detection) and 
	the help text will indicate the name of the missing help.</p>

	<li><p><b>url</b>: The url to use in the generated <a> tag.  
	Normally this defaults to "javascript:void()", which means
	that nothing will happen when the user clicks the help link.  
	We recommend not overriding the default. Ignored if attrs_only 
	is true.</p>

	<li><p><b>attrs_only</b>: If this option is provided as a 
	true value, no link is output; but the return value from the
	call is a set of attributes suitable for inclusion in your own 
	&lt;a href="..."&gt; tag.</p>
</ul>

<h2>Caveats</h2>

<p>The first time you call this module during a page-view, a Javascript 
library and an HTML layer will be included in your page's output.  This 
may cause an additional line break at the site of your first call to this 
module.  To prevent this from interfering with your page flow, we recommend
calling this component near the top of your page that displays popuop help 
links:</p>

<pre><% <<EOD
<\& /help.m \&\>
EOD
 |h %></pre>

<h2>Another Example</h2>
<p>This example shows the use of attrs_only:</p>

<pre><% <<EOD
<a href="javascript:foobar()" <\% /help.m, 
  attrs_only => 1, 
  text => 'sample help text' 
\%\>><img src="..." alt="a different help image"></a>
EOD
 |h %>
</pre>

</%method>
<%method .doc_synopsis>
Displays a help icon with a floating popup help box.
</%method>

<%shared>
my $included = 0;
</%shared>
<%args>
$text => ''
$url => 'javascript:void(0);'
$name => undef
$attrs_only => 0
</%args>
% if( ! $included ) {
<SCRIPT LANGUAGE="JavaScript" SRC="/overlib_mini.js" type="text/javascript"></SCRIPT>
<DIV ID="overDiv" STYLE="position:absolute; visibility:hidden; z-index:1000;"></DIV>
%	$included ++;
% }
<%perl>
return unless $text || $name;
my $good;
if( $text ) {
	$good = "";
} else {
	$good = 'style="border: 1px solid red" ';;
	$text = "No help for '$name'" unless $text;
}
$text =~ s|\\|\\\\|g;  # backwhack any literal backwhacks
$text =~ s/'/\\'/g;	   # backwhack any quote marks (single)
$text =~ s/"/&quot;/g; # html-escape any quote marks (double)
$text =~ s/\n/ /g;
my $attrs = 
	qq{onMouseOver="return overlib('$text',CAPTION, 'Help',FGCOLOR, '#EAEAEA',BGCOLOR, '#000033',}.
	qq{CSSSTYLE, TEXTCOLOR, '000000',CAPCOLOR, 'FFFFFF',TEXTFONT, 'Verdana,}.
	qq{Geneva, Arial, Helvetica, sans-serif',CAPTIONFONT, 'Verdana,}.
	qq{Geneva, Arial, Helvetica, sans-serif',TEXTSIZE, '10',CAPTIONSIZE,}.
	qq{'18',DELAY, 250, RIGHT}.
#	qq{,VCENTER)"};
	qq{)" onMouseOut="nd();"};
return $attrs if $attrs_only;
</%perl>
<A HREF="<% $url %>" <% $attrs
%>><img src="/help_ico.gif" <% $good %>border=0 alt="" HSPACE="3" ALIGN="top" width="18" height="18"></A>\

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

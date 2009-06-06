<%method .doc_synopsis>
Produce an HTML dump of the information returned by a database query
</%method>
<%method .doc>
<h2>Usage</h2>

<p>This module takes a query and produces HTML to simply display the 
results in a web page.  For example:</p>
<pre><% <<EOD
<\& /db_dump.m,
	query => "SELECT * from jobs"
	table => 'width="100%"'
	th => 'align=left'
	# other options
&\> 
EOD
 |h %></pre>

<h2>Parameters</h2>

<p>Options recognized by this module:</p>

<ul>

	<li><p><b>query</b> (required): The SQL query to execute.  This is the only
	required option for this module.</p>

	<li><p><b>db</b>: The database handle to query against.  Defaults to the 
	global $dbh that's already set up for you (if any).</p>
	
	<li><p><b>table</b>: HTML attributes to use for the TABLE tag</p>

	<li><p><b>trh</b>: HTML attributes for the TR tag for the header row</p>

	<li><p><b>th</b>: HTML attributes for the TH tags</p>

	<li><p><b>tr</b>: HTML attributes for the TR tags for the data rows</p>

	<li><p><b>td</b>: HTML attributes for the TD tags for the data</p>

	<li><p><b>with_nulls</b>: Set this parameter to 1 if you want to see 
	&lt;NULL&gt; to represent NULL values in the result set.</p>

	<li><p><b>raw_field_names</b>: Set this option to disable automatic
	pretty-izing of field names ( _ to space, ucfirst words).</p>

</ul>

</%method>
<%init>
my $handle = $db || $dbh;

my $rv = [];
my $sth = $handle->prepare( $query );
</%init>
% unless( $sth->execute() ) {
<p style="color:red"><% $sth->errstr() %></p>
Query: <pre style="margin:.1in;padding:5px;border:1px solid black"><% $query |h %></pre>
%	return;
% }
<table <% $table %>>
<tr <% $trh %>>
% foreach( @{ $sth->{NAME_lc} } ) {
% my $name = $_;
% $name = join " ", map { ucfirst lc $_ } split "_", $_
%	unless $ARGS{raw_field_names};
<th <% $th %>><% $name %></th>
% }
</tr>
% while( my $rec = $sth->fetchrow_hashref() ) {
<tr <% $tr %>>
%	foreach( @{ $sth->{NAME_lc} } ) {
<td <% $td %>>
%	if( defined $rec->{ $_ } || ! $with_nulls ) {
	<% $rec->{ $_ } |h %>
%	} elsif( $with_nulls && ! defined $rec->{ $_ } ) {
	&lt;NULL&gt;
%	}
</td>
%	}
</tr>
% }
</table>


<%args>
$query
$DEBUG => 0
$db => ''
$table => ''
$trh => ''
$th => ''
$tr => ''
$td => ''
$with_nulls => 0
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

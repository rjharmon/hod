<%method .doc_synopsis>
Prepares a query and returns the first row and column from the result set.
</%method>
<%method .doc>
<h2>Usage</h2>
<pre>
<% <<EOD
my \$time = \$m->comp( '/db_single_item.m',
    query => "SELECT now()" # or other single-element query
);

... # use \$time as appropriate
EOD
|h %>
</pre>

<h2>Requirements</h2>
<p>This module requires that a global $dbh be set up to handle all database requests.</p>
</p>

<h2>Parameters</h2>
<ul>
	<li><p><b>query</b>: The SQL query to execute.  Should return exactly one row from the 
	database, and should have exactly one column.  </p>

	<li><p><b>args</b>: An ordered list of arguments - or a single argument - to insert 
	in replacement of any <code>?</code> placeholders in the query.  </p>

	<li><p><b>db</b>: A database handle to use for the query instead of the default 
	global $dbh.</p>

	<li><p><b>DEBUG</b>: Enables logging of the query and result to the web server's 
	error log, for debugging at development time.</p>
</ul>
<h2>Notes</h2>

<p>Only the first row is fetched from the result set before the
query is destroyed.  Not fetching the entire result set may have 
negative ramifications, depending on your database.</p>

<p>If your query has multiple columns in its row, this module 
will return only the first column.  </p>

Use <a href="/doc.html?module=/db_fetch.m">db_fetch.m</a> to fetch multiple
rows or multiple columns from the database, or use the global $dbh directly.
</p>

</%method>
<%args>
$query
$DEBUG => 0
$args => []
$db => $dbh
</%args>
<%init>
warn "query: $query" if $DEBUG;
my $sth = $db->prepare( $query );
die( "args => must be an array reference or a simple scalar, not $args" )
	unless( ref( $args ) eq 'ARRAY' || !ref($args) );

$args = [ $args ] unless ref( $args );
$sth->execute( @$args );
my @t = $sth->fetchrow_array();
my( $rv ) = $t[0];
warn "returning $rv" if $DEBUG;
return $rv;
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

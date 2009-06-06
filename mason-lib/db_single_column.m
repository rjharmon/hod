<%method .doc_synopsis>
Prepares a query and returns all the values from the first column from the result set as a list.
</%method>
<%method .doc>
<h2>Usage</h2>
<pre>
<% <<EOD
my \$time = \$m->comp( '/db_single_column.m',
    query => "SELECT id from table where ..." # query returns one column
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
	<li><p><b>query</b>: The SQL query to execute.  Should return exactly one column.  </p>

	<li><p><b>DEBUG</b>: Enables logging of the query and result to the web server's 
	error log, for debugging at development time.</p>
</ul>
<h2>Notes</h2>

<p>If your query has multiple columns in its rows, this module 
will return only the first column.  </p>

Use <a href="/doc.html?module=/db_fetch.m">db_fetch.m</a> to fetch multiple
rows or multiple columns from the database, or use the global $dbh directly.
</p>

</%method>
<%args>
$query
$DEBUG => 0
</%args>
<%init>
warn "query: $query" if $DEBUG;
my $sth = $dbh->prepare( $query );
$sth->execute();
my $rv = [];
while( my @t = $sth->fetchrow_array() ) {
	push @$rv, $t[0];
}
warn "returning $#$rv" if $DEBUG;
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

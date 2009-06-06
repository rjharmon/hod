<%method .title>
Record Fetching - Result Set
</%method>
<%method .doc_synopsis>
Prepares a query and returns the result set as an array of hashrefs.
</%method>
<%method .doc>
<h2>Description</h2>

<p>This module uses the default global database handle 
(or a different handle you provide) to prepare and execute an SQL
query, returning the result set as an array.
</p>

<h2>Usage</h2>
<pre>
<% <<EOD
<table>
\% my \$items = \$m->comp( '/db_single_item.m',query => 
\%  "select * from order_item where order_number=?"
\%	args => \$foo
\% );
\%
\% foreach( \@\$items ) {
     <tr><td><\% \$_->{description} %\> </td>
     <td><\% \$_->{quantity} %\></td></tr>
\% }
</table>
EOD
|h %></pre>


<h2>Requirements</h2>
<p>This module requires that a global $dbh be set up to handle all database requests, or 
that the <code>db</code> parameter is provided.</p>
</p>

<h2>Parameters</h2>
<ul>
  <li><p><b>query</b>: The SQL query to execute.  </p>

  <li><p><b>db</b>A database handle as returned by DBI->connect().  This 
   handle will be used to execute the query, overriding the default global $dbh.</p>

   <li><p><b>args</b>A listref of argument values, inserted in place of ? placeholders
	by passing them to $sth->execute().  Accepts a single non-reference value, useful
	if there is only one placeholder.  See the DBI documentation for more details.</p>

  <li><p><b>DEBUG</b>: Enables logging of the query, and (if &gt; 1) the 
  result set, to the web server's error log, for debugging at development 
  time.</p>

</ul>
<h2>Notes</h2>

<p>The returned result set is a reference to an array of hashrefs.  Each hashref
has keys which are column names and values which are column values.</p>

<p>If you fetch a large number of rows from the database with this module, 
a large amount of memory may be consumed.  Use DBI's functions directly if
you plan for such usage.</p>

</%method>
<%init>
my $handle = $db || $dbh;

my $rv = [];
my $a = $args; $a = [ $a ] unless ref( $a );
my $sth = $handle->prepare( $query );
$sth->execute( @$a ) or warn( $query ), return undef;
while( my $rec = $sth->fetchrow_hashref() ) {
	push @$rv, { %$rec };
}
warn "db_fetch: returning ". Data::Dumper::DumperX( $rv ) if $DEBUG > 1;
return $rv;
</%init>
<%args>
$args => []
$query
$DEBUG => 0
$db => ''
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

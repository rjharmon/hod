<%shared>
use HTML::Entities;
use Hod::DB;

my $opts = $m->comp('SELF:_options');
my $DEBUG = $opts->{DEBUG};
</%shared>
<%method .doc_synopsis><b>Query Abstraction Module</b> - Define packaged database queries for your application
</%method>

<%method .doc>
<h2>Usage</h2>

<p>Define a new module that inherits from /db_query.m, for instance: <tt>/cust/best.m</tt></p>

<pre><% <<EOD
<\%flags>
inherit => '/db_query.m'
</\%flags>

<\%method query>
FROM customer where total_volume > 100000
</\%method\>

<\%method select_records>
last_purchase_date, name, total_volume
</\%method>
EOD
 |h %></pre>

<p>This example defines a query that selects the business's best customers - the ones 
whose total sales exceed $100,000.  
</p>

<p>The <b>query</b> method defines everything in the SQL query after (and including) 
the FROM clause.  The <tt>select_records</tt> method defines the fields to be returned
as part of the query (the default is "*").</p>

<p>The <b>flags</b> section defines inheritance for this module, blessing this module 
with the features provided by db_query.m.  Those features include:</p>

<h3>count - return the number of matching records</h3>

<p>Ask your query for the number of matching records, with a call such as:</p>

<pre><% <<EOD
my \$count = \$m->comp('/cust/best.m:count');
EOD
 |h %></pre>

<h3>records - return all the matching records</h3>

<p>Fetch the matching records with a call such as:</p>

<pre><% <<EOD
my \$records = \$m->comp('/cust/best.m:records');
foreach( \@\$records ) { 
  ...
}
EOD
 |h %></pre>

<h3>dump - display all the results as HTML</h3>

<p>Dump the results from the query in a quick-and-dirty HTML format:</p>

<pre><% <<EOD
<\& /cust/best.m:dump &\>
EOD
 |h %></pre>

</%method>

<%method count>
% my $t = "SELECT ". $m->scomp('SELF:select_count') 
%	. " " . $m->scomp('SELF:query');
% warn "$t";
% $t = $m->comp('/db_single_item.m', 
%	db => $opts->{dbh},
%	query => $t
% );
% warn "counted $t records";
% return $t;
</%method>

<%method select_count>
COUNT(*)
</%method>

<%method select_records>
*
</%method>

<%method dump>
<& /db_dump.m, 
	raw_field_names => $opts->{raw_field_names},
	db => $opts->{dbh},
	query => "SELECT ". $m->scomp('SELF:select_records') 
	. " " . $m->scomp('SELF:query')
&>
</%method>

<%method records>
% my $q = "SELECT ". $m->scomp('SELF:select_records') 
%	. " " . $m->scomp('SELF:query');
% my $t = $m->comp('/db_fetch.m',
%	db => $opts->{dbh},
%	query => $q,
%	DEBUG => $DEBUG
% );
% warn( ( $#$+1 ). " records" ) if $DEBUG > 1;
% return $t;
</%method>

<%method page>
</%method>


<%method _options><%init>
warn "debug is $DEBUG";
my $options = $m->comp('SELF:options');
return {
	page_size => '15',
	max_pages => 999,
	optional => 0,
	novcr => 0,
	link_attrs => '',
	dbh => $dbh,
	columns => 1,
	%$options
};
</%init></%method>

<%method options><%init>
return {};
</%init></%method>

<%method option_docs><%init> 
return {
	page_size => 'The number of records displayed per page, default 15',
	max_pages => 'The maximum number of pages to display in the index, default 999',
	index_optional => "Indicates whether the index is optional.  Default 0.  If true, no index is displayed when there's just one page of results.",
	novcr => "Allows the suppression of the VCR-like links in the pager index",
	link_attrs => "HTML attributes for the <a> links in the index",
	dbh => "Database handle to use for the query.  Default is the global $dbh",
	columns => "The number of columns to display per row. ",
};
</%init></%method>

<%method index>
<%args>
$self_url
$optional => 0
</%args>
<%perl>

my( $normal, $selected );
my $args = $m->top_args();
my $list_start = $args->{'B'} || 1;

my $list_prev = ( $list_start < $opts->{page_size} ? 1 : $list_start - $opts->{page_size} );
my $list_next = $list_start + $opts->{page_size};
my $total_items = $m->comp( 'SELF:count' );

my $start_page = 1;
my $total_pages = int( ( $total_items - 1 ) / $opts->{page_size} ) + 1;
my $stop_page = $opts->{max_pages}; $stop_page = $total_pages if $total_pages < $opts->{max_pages};
my $current_page = int( ( $list_start - 1 ) / $opts->{page_size} ) + 1;
while ( ! (
	( $stop_page == $total_pages ) ||
	( $start_page  + int( $opts->{max_pages} / 2 ) > $current_page )
) ) {
	$start_page ++;
	$stop_page ++;
}

</%perl>
% if( $total_pages == 1 ) {
% return if $opts->{optional};
Page 1 of 1
% return;
% }

<nobr>
% if( $current_page != 1 && ! $opts->{novcr} ) {
	<a href="<% $self_url %>B=1"<% $normal %> <% $opts->{link_attrs} %>>&laquo;</a>
	<span<% $normal %>>[&nbsp;<a href="<% $self_url %>B=<% $list_start - $opts->{page_size} %>" <% $ARGS{link_attrs} %>>Prev Page</a>&nbsp;]</span>
% }
% my $page_number = $start_page;
% while( $page_number <= $stop_page ) {
% 	if( $page_number == $current_page ) {
		<span<% $selected %>><% $page_number %></span>
%	} else {
		<a href="<% $self_url %>B=<% ( $page_number - 1 ) * $opts->{page_size} + 1 %>"<% $normal %> <% $opts->{link_attrs} %>><% $page_number %></a>
%	}
%	$page_number++;
% }
%
% if( $current_page < $total_pages && ! $opts->{novcr} ) {
	<span<% $normal %>>[&nbsp;<a href="<% $self_url %>B=<% $list_next %>" <% $opts->{link_attrs} %>>Next&nbsp;Page</a>&nbsp;]</span>
%	my $last_page_start = $total_items - ( ( $total_items % $opts->{page_size} ) - 1 );
%	$last_page_start -= $opts->{page_size} if $last_page_start > $total_items;
	<a href="<% $self_url %>B=<% $last_page_start %>"<% $normal %> <% $opts->{link_attrs} %>>&raquo;</a>
% }
</nobr>

</%method>







<%method pager>
<%init>
my $args = $m->top_args();
my $_dbh = $opts->{dbh};
my $list_start = $args->{'B'} || 1;
my $page_size = $opts->{page_size};
my $context = { record_count => 0 };
my $cols = $opts->{columns};

my( $options, $definitions ); 
if( $opts->{definition} ) { 
	( $options, $definitions ) = $m->comp( $opts->{definition} );
}

my $limit_clause = "limit " . ( $list_start - 1 ) . ", $page_size";

my $sql = "SELECT ". $m->scomp('SELF:select_records') . " ".
	$m->scomp('SELF:query'). " $limit_clause";

warn $sql if $DEBUG;

my $items = $m->comp( '/db_fetch.m', query => $sql, db => $_dbh );

$m->comp("SELF:pager_top");

warn( ($#$items+1). " items" ) if $DEBUG;

warn Data::Dumper::Dumper( $items ) if $DEBUG > 1;

if( $#$items == -1 ) {
	$m->comp( "SELF:pager_no_records", %$args );
}
my $i = 0;
while( $#$items > -1 ) {
	$i = 1 - $i;
	my $row = $m->scomp("SELF:pager_row", odd => $i);
	my $some_items = [ map { shift @$items } 1 .. $cols ];
	$row =~ s/<items(?: callback="?(\S+)"?)?>/  # replace with:
		my $cb = $1 || "pager_item";
		my $t = $m->scomp("SELF:do_items", 
			callback => $cb, 
			items => [ @$some_items ],
			columns => $cols,
			opts => $options,
			defs => $definitions
		);
		$t
	/egi;
	$m->out( $row );
}
$m->comp("SELF:pager_bottom");
return;
</%init>
</%method>

<%method pager_no_records>
<tr><td>No records found</td></tr>
</%method>

<%method pager_row>
<tr valign=top class="table_row_<% $ARGS{odd} ? "odd" : "even" %>"><items></tr>
</%method>

<%method pager_top>
<table style="border:2px solid black;" cellspacing=0 cellpadding=4>
</%method>

<%method pager_bottom>
</table>
</%method>

<%method pager_item>
<td>No <tt><b>pager_item</b></tt> defined.</td>
</%method>

<%method do_items>
<%args>
$callback
$items
$columns
$opts => undef
$defs => undef
</%args>
<%init>
warn "doing $columns items";
foreach( 1..$columns ) {
	my $item = shift @$items;
	my $result = $m->scomp("SELF:$callback", item => $item );
	$result =~ s/(\s+)?<display name="?(\w+)"? ?([^>]*)>/
		$m->comp( "SELF:field_xlat", 
			item => $item, 
			field_name => $2, 
			attrs => $3, 
			indent => $1, 
			opts => $opts, 
			def => $defs, 
			DEBUG => $DEBUG 
		)
	/ige;
	$m->out( $result );
}
</%init>
</%method>


<%method field_xlat>
<%args>
$item
$field_name
$attrs
$indent
$opts => undef
$def => {}
$DEBUG => 0
</%args>
<%init>
{ my $doc = <<DOC;
Translates <display name="name" ...> to a useful (usually textual) display
for that field name, according to the record definition, including:

	- current field value from \$item
	- the attributes ("..." above) may be used by the field class's formatting routine
    - appropriate indention for pretty display
DOC
}

my $value = $item->{$field_name};
warn "field def is $def->{$field_name}" if $DEBUG > 1;
warn "path to 'definition' needed in 'options' callback, to properly translate <field>s"
	if $DEBUG;

if( $def->{$field_name} =~ /^(.*)\.pm$/ ) {
	my $class = "Hod/Field/$def->{$field_name}";
	warn "loading class $class" if $DEBUG > 2;
	eval { require $class; 1 } or warn "$class not found";
	$class = "Hod::Field::$1";

	my $options = $opts->{$field_name};

	if( my $display = UNIVERSAL::can( $class, 'html_display' ) || UNIVERSAL::can( $class, 'display_value' ) ) {
		warn "sending $field_name ($value) for display" if $DEBUG > 2;
		$value = $display->( $class, $field_name, $value, $attrs, $options, $indent );
		warn "$_ display: $value" if $DEBUG > 2;
		return "$indent$value";
	} else {
		warn "$field_name: $class can't html_display() or display_value(); outputting as-is" if $DEBUG;
	}
} else {
	warn "$field_name is a regular field" if $DEBUG > 1;
}
my $disp = encode_entities( $item->{$field_name} );
return qq($indent$disp);

</%init>
</%method>


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

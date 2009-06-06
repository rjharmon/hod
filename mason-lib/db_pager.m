<%method .title>
Database Records - Display Pages of Data
</%method>
<%method .doc_synopsis>
Display records from a table, using a paged display to manage 
even larger recordsets.
</%method>

<%method .doc>
<h2>Usage</h2>

<p>To use this module, first define an options structure.  For example:</p>

<pre><% <<EOD
<\%init>
my \$pager_options = {
	definition => "/store/catalog/definition.m",
	order => "short_description",
	self_url => "/product_list.html",
}
</\%\init>
EOD
 |h %></pre>

<p>Next, define any HTML you want to occur before and after items are displayed:</p>

<pre><% <<EOD
<table>
   <tr>
      <th>My header</th>
      <th>columns</th>
   </tr>

   <!-- items will be displayed here -->

<tr><td colspan=2><a href="...">Add a record</a></td></tr>
</table>
EOD
 |h %></pre>

<p>Insert a call to <code>/db_pager.m</code> ('list' mode) to insert rows from the 
database, in place of the <code>&lt;!-- items will be displayed here --&gt;</code> 
comment above:</p>

<pre><% <<EOD
<\& /db_pager.m, 
   \%\$pager_options, 
   mode => 'list', 
   args => \\\%ARGS 
&\>
EOD
 |h %></pre>

<p>And, anywhere within your content you wish, add a call ('index' mode) to
insert an index of pages for navigating the recordset:</p>

<pre><% <<EOD
<\& /db_pager.m, 
   \%\$pager_options, 
   mode => 'index', 
   args => \\\%ARGS 
&\>
EOD
 |h %></pre>

<p>Finally, define the HTML that will be inserted for each item in the database:</p>

<pre><% <<EOD
<\%def .pager_item>
<\%args>
\$item
</\%args>
<tr>
   <td><display name="short_description"></td>
   <td><display name=price></td>
</tr>
</\%def .pager_item>
EOD
 |h %></pre>

<P>Optional: <a href="#filters">record filtering and reporting</a>, <a href="#cols">showing a columnar
display of records</a>, <a href="#advanced">other advanced usage</a>.</p>

<h2>Description</h2>

<p>This module provides a framework for displaying a limited portion of records
from the database.

<h2>Parameters</h2>

<ul>

	<li><p><b>mode</b>: selects from different modes of operation:</p>

	<ul>

		<li><p><b>'list'</b>: Displays the records on this page of the recordset.</p>

		<li><p><b>'index'</b>: Displays an index of pages for this recordset.</p>

		<li><p><b>'filter'</b>: Displays the form for filtering the recordset.</p>

		<li><p><b>'where_clause'</b>: <em>Returns</em> the SQL <code>WHERE</code> 
		clause used to display the recordset.  Useful for debugging, as well as for
		querying for SUM information about the recordset.</p>

	</ul>

	<li><p><b>fields</b> (default: *): a comma-separated list of field names to
	select from the table.  <em>Advanced Usage:</em> You may include any SQL 
	valid between <code>SELECT</code> and <code>FROM</code>.</p>

	<li><p><b>table</b>: The name of the database table used for selecting
	rows.  <em>Advanced Usage:</em> You may include any SQL syntax valid 
	between <code>FROM</code> and <code>WHERE</code>, such as for joining 
	tables. If omitted, the table name from the definition file will be used.</p>

	<li><p><b>where</b>: An SQL <code>WHERE</code> clause that filters records 
	displayed for the user.  <em>Advanced Usage</em>: You may include any valid 
	SQL <code>WHERE</code> for filtering the recordset or creating custom reports. </p>

	<p>WARNING: <b>do not simply include a user parameter
	directly for this option.</b>  That could open you to security risks.  This 
	parameter is useful for imposing hard-coded restrictions on the records that
	will be displayed, for instance, limiting the display of account detail 
	information only to those details for the client who's currently logged in.</p>

	<li><p><b>order</b>: An SQL <code>ORDER BY</code> clause that specifies a
	sorting order.  As with the previous warning, there are potential security risks. 
	Therefore, we recommend hard-coding this, or using a switch-type statement
	to explicitly set it to one of a known set of hard-coded values.</p>

	<li><p><b>group</b>: An SQL <code>GROUP BY</code> clause that specifies a
	GROUP setting.  See the security warnings above, and hew to them.  NOTE:
	GROUP BY clauses <b>change</b> the results you get from your query.  If you
	are not experienced with SQL's GROUP BY, <em><b>expect</b> to get unexpected results!</em>

	<li><p><b>definition</b>: The component path to a definition of the record,
	used when inserting field values with <code><% '<display name="fieldname">'
	|h %></code> syntax.</p>

	<li><p><b>self_url</b>: The URL to be used for navigating to other pages of this 
	recordset.  Include any parameters that you may be using to retain state, such
	as display options.</p>

	<li><p><b>page_size</b> (default: 15): The number of records to display per
	page.  Note that this option is not affected by the number of columns
	selected.  If you set a number of columns, we recommend setting the
	<code>page_size</code> to a multiple of <code>columns</code></p>

	<li><p><b>columns</b> (default: 1): The number of columns of records to
	display, for columnar layouts.  In other words, the number of items per
	row.  You'll need to define <code>.pager_row_start</code> and
	<code>.pager_row_end</code> to get your desired results.  See 
	<a href="#cols">showing a columnar display of records</a>.</p>

	<li><p><b>max_pages</b> (default: 10): How many page numbers will be displayed
	in the index of pages.  If there are more than this number of pages, only
	this number of page numbers will be displayed at one time.  For example, with
	the default setting, page 7 of 20 will have an index running from page 3 to 12.  
	The first and last rows of the recordset can always be displayed with their 
	respective links.</p>
	</p>

	<li><p><b>optional</b> (default: 0): Indicates that the index should
	be omitted if there is only one page.  By default, "Page 1 of 1" is
	displayed in this case.</p>

	<li><p><b>normal</b>: The CSS class name used for index page numbers which are not
	the current page.</p>

	<li><p><b>selected</b>: The CSS class name used for the current page number.</p>

	<li><p><b>extra_fields</b>: Additional HTML form fields used in the filtering form.</p>

</ul>

<h2>Callbacks</h2>

<p>TODO</p>
	
</%method>


<%once>
my $DEBUG = 0;
use Hod::DB;
use HTML::Entities;
my $_dbh;
</%once>

<%args>
$where => 1
$order => undef
$group => undef
$page_size => 15
$max_pages => 10
$fields => undef
$table => undef
$columns => 1
$args
$mode
$self_url
$definition => undef
$db => undef
$extra_fields => ''
$optional => 0
</%args>
<%init>
$_dbh = $db || $dbh;
$DEBUG = $ARGS{DEBUG} if defined $ARGS{DEBUG};
$definition &&= $m->fetch_comp( $definition ) || undef;
my( $def, $opts ) = $m->comp( $definition ) if $definition;
unless( $definition ) {
	die( 'Development Error: db_pager.m: required param \'definition\' must point to a record definition component.');
}$table ||= $opts->{table};

my $caller = $m->callers(1);
$caller = $caller->parent_comp if( $caller->is_subcomp() );
my $item_display = $caller->subcomps('.pager_item');
my $none_found = $caller->subcomps('.not_found') || '.none_found';
my $row_start = $caller->subcomps('.pager_row_start') || '.null';
my $row_end = $caller->subcomps('.pager_row_end') || '.null';

$ARGS{fields} ||= "*";
$ARGS{max_pages} ||= 10;

if( $self_url =~ /\?/ ) {  # prepare the URL for taking additional CGI parameters
	$ARGS{self_url} .= "&";  # depending on whether it already has a question mark in it.
} else {
	$ARGS{self_url} .= "?";
}
if( $mode eq 'list' ) {
	unless( $item_display ) {
		die( "Development Error: Caller to db_pager.m must have .pager_item defined in order to output rows" );
	}
 	return $m->comp( '.list', %ARGS, 
		item_display => $item_display, 
		none_found => $none_found, 
		row_start => $row_start,
		row_end	=> $row_end,

		def => $def, 
		opts => $opts 
	);
} elsif( $mode eq 'index' ) {
	return $m->comp( '.index', %ARGS, def => $def, opts => $opts );
} elsif( $mode eq 'count' ) {
	return $m->comp('.index', %ARGS, def => $def, opts => $opts, count => 1 );
} elsif( $mode eq 'filter' ) {
	return $m->comp( '.filter', %ARGS, def => $def, opts => $opts );
} elsif( $mode eq 'where_clause' ) {
	return $m->comp( '.filter_where', %ARGS, def => $def, opts => $opts );
}
</%init>

<%def .null></%def>

<%def .error>
<%args>
$text
</%args>
<h1>Development Error</h1>

<p><% $text %></p>
<p>For more information, please see the 
<a href="/doc.html?module=/db_pager.m">documentation for /db_pager.m</a>.
</p>
</%def>

<& .error, text => <<EOD,
<code>/db_pager.m</code> requires a 'mode' parameter.  Examples:
<table border=1>
	<tr><th>mode</th><th>Behavior</th></tr>

	<tr><td>list</td><td>Display records</td></tr>
	
	<tr><td>index</td><td>Display an index of pages</td></tr>
	
	<tr><td>filter</td><td>Display a form for selecting filtering options</td></tr>

	<tr><td>count</td><td>Return a count of records matching the current filter settings</td></tr>

	<tr><td>where_clause</td><td>Return the SQL 'WHERE' clause for the current filter settings</td></tr>
</table>
EOD
foo => 'bar'
&>
% return;

<%def .list>
<%args>
$where => 1
$order => undef
$group => undef
$page_size => 15
$table
$args
$columns => 1
$mode
$self_url
$fields
$item_display
$more_fields => ''
$opts => undef
$def => undef
$none_found
$row_start
$row_end
</%args>
<%init>
my $list_start = $args->{'B'} || 1;

my $context = { record_count => 0 };


my $search_clause = "where ". $m->comp( '.filter_where', opts => $opts, args => $args, %ARGS );

$search_clause .= " group by $group " if $group;

$search_clause .= " order by $order " if $order;


my $limit_clause = "limit " . ( $list_start - 1 ) . ", $page_size";

warn "fields: ". Data::Dumper::DumperX( $fields ) if $DEBUG > 1;

my $sql = "SELECT ". 
	( ref( $fields ) ? join( ", ", @$fields ) : $fields ).
	( $more_fields ? ", $more_fields" : "" ).
	" FROM $table $search_clause $limit_clause";

warn $sql if $DEBUG;

my $items = $m->comp( '/db_fetch.m', query => $sql, db => $_dbh );

warn( ($#$items+1). " items" ) if $DEBUG;

warn Data::Dumper::Dumper( $items ) if $DEBUG > 1;

if( $#$items == -1 ) {
	$m->comp( $none_found, %$args );
}

foreach my $item ( @$items ) {
	my $result;

	if( ! ( $context->{record_count} % $columns ) ) {    # for every Nth item
		if( $context->{record_count} ) {  # end the previous row
			$m->comp( $row_end, %$args ); #   (if applicable)
		}
		# start a new table row
		$m->comp( $row_start, %$args );
	}
	$m->comp( $item_display, %$args, item => $item, STORE => \$result );
	$result =~ s/(\s+)?<display name="?(\w+)"? ?([^>]*)>/$m->comp( ".field_xlat", item => $item, field_name => $2, attrs => $3, indent => $1, opts => $opts, def => $def, DEBUG => $DEBUG )/ige;
	$_out->( $result );

	$context->{record_count}++;
}
return;
</%init>
</%def>

<%def .field_xlat>
<%args>
$item
$field_name
$attrs
$indent
$opts => undef
$def => undef
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
die "must provide the full site-path to this record's definition-component"
	unless $opts && $def;

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
</%def>


<%def .index>
<%args>
$where => 1
$order => undef
$group => undef
$page_size => 15
$table
$args
$mode
$def
$opts
$self_url
$max_pages
$normal => ''
$selected => ''
$count => undef
$optional => 0
</%args>
<%perl>

$normal &&= " class=\"$normal\"";
$selected &&= " class=\"$selected\"";


if( my $filters = $opts->{filters} ) {
	foreach my $filt( @{ $filters->{_order} || [ keys %$filters ] } ) {
		$self_url .= ( "$filt=". $args->{$filt}. "&" ) if $args->{$filt};
	}
}

my $list_start = $args->{'B'} || 1;

my $search_clause = "where " . $m->comp( '.filter_where', opts => $opts, args => $args, %ARGS );

$search_clause .= " group by $group " if $group;

$search_clause .= " order by $order " if $order;

my $limit_clause = "limit " . ( $list_start - 1 ) . ", $page_size";

my $list_prev = ( $list_start < $page_size ? 1 : $list_start - $page_size );
my $list_next = $list_start + $page_size;
my $total_items = $m->comp( '/db_fetch.m', query => "select count(*) as count from $table $search_clause", db => $_dbh );
$total_items = $total_items->[0]->{'count'};

return $total_items if $count;

my $start_page = 1;
my $total_pages = int( ( $total_items - 1 ) / $page_size ) + 1;
my $stop_page = $max_pages; $stop_page = $total_pages if $total_pages < $max_pages;
my $current_page = int( ( $list_start - 1 ) / $page_size ) + 1;
while ( ! (
	( $stop_page == $total_pages ) ||
	( $start_page  + int( $max_pages / 2 ) > $current_page )
) ) {
	$start_page ++;
	$stop_page ++;
}

</%perl>
% if( $total_pages == 1 ) {
% return if $optional;
Page 1 of 1
% return;
% }

<nobr>
% if( $current_page != 1 && ! $ARGS{novcr} ) {
	<a href="<% $self_url %>B=1"<% $normal %> <% $ARGS{link_attrs} %>>&laquo;</a>
	<span<% $normal %>>[&nbsp;<a href="<% $self_url %>B=<% $list_start - $page_size %>" <% $ARGS{link_attrs} %>>Prev Page</a>&nbsp;]</span>
% }
% my $page_number = $start_page;
% while( $page_number <= $stop_page ) {
% 	if( $page_number == $current_page ) {
		<span<% $selected %>><% $page_number %></span>
%	} else {
		<a href="<% $self_url %>B=<% ( $page_number - 1 ) * $page_size + 1 %>"<% $normal %> <% $ARGS{link_attrs} %>><% $page_number %></a>
%	}
%	$page_number++;
% }
%
% if( $current_page < $total_pages && ! $ARGS{novcr} ) {
	<span<% $normal %>>[&nbsp;<a href="<% $self_url %>B=<% $list_next %>" <% $ARGS{link_attrs} %>>Next&nbsp;Page</a>&nbsp;]</span>
%	my $last_page_start = $total_items - ( ( $total_items % $page_size ) - 1 );
%	$last_page_start -= $page_size if $last_page_start > $total_items;
	<a href="<% $self_url %>B=<% $last_page_start %>"<% $normal %> <% $ARGS{link_attrs} %>>&raquo;</a>
% }
</nobr>

</%def>

<%def .none_found>
No records found
</%def>


<%def .filter>
<%args>
$where => 1
$order => undef
$group => undef
$page_size => 15
$table
$args
$mode
$self_url
$fields
$more_fields => ''
$opts => undef
$def => undef
</%args>
<%init>
	unless( $opts ) {
		$m->comp('.error', text => <<EOD );
To use record filters, the record definition must be provided and
have filters defined in its options.
EOD
		return;
	}
	my $filters = $opts->{filters};
	unless( $filters ) {
		$m->comp('.error', text => <<EOD );
To use record filters, there must be filters defined in the record's 
options structure.
EOD
		return;
	}

my $url = $self_url;
my $url_args;
$url =~ s/([^\?]+)\?(.*)/$1/;
$url_args = $2;

</%init>
% my $count = 0;
<form style="margin:0;display:inline" method=get action="<% $url %>">
% foreach my $arg( split '&', $url_args ) {
%	my( $name, $value ) = ( $arg =~ m/([^=]+)=(.*)/ );
	<input type=hidden name="<% $name %>" value="<% $value %>">
% }
% foreach my $filt( @{ $filters->{_order} || [ keys %$filters ] } ) {
<nobr>\
% 	if( $filters->{$filt}{type} ) {
		<% $filters->{$filt}{label} || $filt %>: \
%		$count++;
% 	}
		<% $m->comp( '/html_field.m', 
			name => $filt,
			value => $args->{$filt} || $filters->{$filt}{default},
			def => $filters->{$filt}{type},
			opts => $filters->{$filt}{options},
			attrs => $filters->{$filt}{attrs},
			DEBUG => $DEBUG - 1,
		) %>\
% 	if( $filters->{$filt}{type} ) {
%	 	if( $filters->{$filt}{help} ) {
<& /help.m, text => $filters->{$filt}{help} &>
%		}
%	}
</nobr>
% }
<% $ARGS{extra_fields} %>
% if( $ARGS{extra_fields} || $count ) {
<input type=submit value="Refresh">
% }
</form>
</%def>

<%def .filter_where>
<%args>
$opts
$args
$where => undef
</%args>
<%init>
my $quoted_args = {};
$where ||= "1";
if( my $filters = $opts->{filters} ) {
	foreach my $filt( @{ $filters->{_order} || [ keys %$filters ] } ) {
		my $spec = $filters->{$filt};
		$args->{$filt} ||= $spec->{default};
		if( ! $args->{$filt} ) {
			# this may be by design, but we want to catch it when debugging.
			warn "filter $filt: no default setting; not filtering.  Hope that's what you want.\n" 
				if $DEBUG;
			next;
		}
		my $v = $args->{$filt};
		if( $spec->{type} =~ /^(.*)\.pm$/ ) {
			my $class = "Hod/Field/$spec->{type}";
			eval { require $class; 1 } or warn "$class not found";
			$class = "Hod::Field::$1";
			if( $class->can( 'set_value' ) ) {
				my $error;
				( $v, $error ) = $class->set_value( {}, $v, $spec->{options} );
				if( ! defined $v ) {
					$args->{$filt} = $error || "unknown error";
					next;
				}
			}
		}
		$quoted_args->{ $filt } = $_dbh->quote( $args->{$filt} );
	}
	foreach my $filt( @{ $filters->{_order} || [ keys %$filters ] } ) {
		my $wh = $filters->{$filt}{where};

		# this is a coding error; always warn:
		warn( "filter $filt doesn't have a 'where' specification; skipping" ), 
			next unless $wh;

		next unless $args->{$filt};

		if( ref($wh) eq 'CODE' ) {
			$wh = $wh->( { %$args }, $quoted_args );
			warn ("filter $filt returned nothing from its 'where' sub {...}; skipping\n"), 
			warn ("\t(return 0 if you don't want to filter)\n"),
				next unless defined( $wh ) && length( $wh ); 
		}
		$where .= " AND ( $wh ) ";
		warn "\t$filt\: $wh\n" if $DEBUG > 2;
	}
}
warn "Filter: where clause is '$where'" if $DEBUG > 1;
return $where;
</%init>
</%def>
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


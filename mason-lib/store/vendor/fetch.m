<%args>
$id => undef
$DEBUG => 0
</%args>
<%init>
if( defined $id ) {
	return $m->comp( '/record.m', action => 'fetch', id => $id, definition => '/store/vendor/definition.m', DEBUG => $DEBUG );
} else {
	my $rec = $m->comp('/db_fetch.m', query => "SELECT * from order_vendor where default_vendor = 'x'" );
	return $rec->[0];
}
</%init>

<%args>
$sku
$DEBUG => 0
</%args>
<%init>
return $m->comp( '/record.m', action => 'fetch', sku => $sku, definition => '/store/catalog/definition.m', DEBUG => $DEBUG );
</%init>

<%args>
$sku
$DEBUG => 0
</%args>
<%init>
# zaps color specifiers from the end of SKU numbers.
my $zap = sub { $_[0] =~ s/.*: (.*)/$1/; return $_[0]; };

my $sql = "select * from product where sku";
if( wantarray ) {
	$sku = [ $sku ] unless ref( $sku ) eq 'ARRAY';
	$sql .= " in ( ". join( ", ", map { $dbh->quote( $zap->($_) ) } @$sku ) . " )";
} else {
	die "List context requried to fetch a list of SKU's" if ref( $sku ) eq 'ARRAY';
	$sql .= "= ". $dbh->quote( $zap->( $sku ) );
}
my $items = $m->comp('/db_fetch.m', query => $sql ) || [];
warn "$sql: ". Data::Dumper::DumperX( $items ) if $DEBUG;
return $items->[0] unless wantarray;
return @$items;
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

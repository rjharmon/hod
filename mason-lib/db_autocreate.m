<%args>
$def
$opts => undef
$db_defs => undef
$sql
</%args>
<%once>
use HTML::Entities;
</%once>
<%init>
my $DEBUG = 2;

my $_dbh = $ARGS{dbh} || $dbh || die "No database connection is available";

my $orig_error = $ARGS{orig_error} = $_dbh->errstr();
my $custom_def;

unless( ref( $def ) ) {
	$def = eval { [ $m->comp($def) ] };
	warn "def is ". Data::Dumper::Dumper( $def );
	unless( ref( $def ) eq 'ARRAY' ) {
		die "\$def must be either a hashref of Hod::Field definitions,\n".
			"or must be a component path to the record definition.  Instead, it's ".
			Data::Dumper::Dumper( $def );
	}	
	$ARGS{opts} = $opts = $def->[1];
	$ARGS{db_defs} = $db_defs = {};
	$custom_def = $def->[2] || {};
	$ARGS{def} = $def = $def->[0];

} else {
	$custom_def = $db_defs || {};
	$ARGS{db_defs} = $db_defs = {};
}
my $cfgerr;
if( ! $db_defs ) { $cfgerr = "record definition requires third hashref with field definitions." }
if( ! $opts->{table} ) { $cfgerr = "record options' 'table' entry must specify the table name" }
if( ! $opts->{primary} ) { $cfgerr = "record options' 'primary' entry must specify the primary key fields" }

foreach( keys %$def ) {
	if( $custom_def->{$_} ) {
		$db_defs->{$_} = $custom_def->{$_};
	} else {
		my $pr = $opts->{primary};
		$pr = [ $pr ] unless ref( $pr ) eq 'ARRAY';
		# if there's one primary key field, and this is it,
		if( $#$pr == 0 && $_ eq $pr->[0] ) {
			$pr = 1;
		} else {
			$pr = 0;
		}
		my $rwef = Hod::DB::field_type( $def->{$_}, $pr );
		$db_defs->{$_} ||= $rwef;
		$cfgerr = "Unknown definition for $def->{$_} column '$_':\n\t".
			"explicit field definition required in third hashref of record definition"
		unless $rwef;
	}
}
warn "db_defs: ". Data::Dumper::Dumper( $db_defs );
if( $orig_error =~ /Table '([a-z\._]+)' doesn't exist/ ) {
	if( $cfgerr ) {
		$cfgerr = "Table $1 doesn't exist, but can't create:\n\t". $cfgerr;
		$m->comp( '.table_mod_error', %ARGS, error => $cfgerr );
		return -1;
	}
 	return $m->comp('.create', db => $_dbh, %ARGS );
} elsif( $orig_error =~ /Unknown column '([a-zA-Z_0-9]+)' in 'field list'/ ) {
	if( $cfgerr || ! $db_defs->{$1} ) {
		$cfgerr ||= "explicit field definition required in third hashref of record definition";
		$cfgerr = "Column $1 doesn't exist, but can't create:\n\t". $cfgerr;
		$m->comp( '.table_mod_error', %ARGS, mod_sql => undef, error => $cfgerr );
		return -1;
	}
	return $m->comp('.alter', db => $_dbh, %ARGS );
} else {
	warn "No match: $orig_error" ;
}
return undef;
</%init>


<%def .create>
<%args>
$def
$opts
$db_defs
$sql
$orig_error
$db
</%args>
<%init>
my $primary = $opts->{primary};  
$primary = [ $primary ] unless ref( $primary ) eq 'ARRAY';

my $create_sql = "CREATE TABLE $opts->{table} (\n".
	join( "\n", map { "\t$_ $db_defs->{$_}," } 
		sort keys %$db_defs ) .
	join( "\n", map { "\tKEY $_ ($opts->{keys}{$_})," } 
		( keys %{ $opts->{keys} || {} } ) ).
	"\tprimary key(". join( ",", @$primary ) .")\n".
")";

warn "Table '$opts->{table}' in database doesn't exist.  Creating...\n";
unless( $db->do( $create_sql ) ) {
	$m->comp( '.table_mod_error', %ARGS, mod_sql => $create_sql, error => $db->errstr() );

	return -1;
} else {
	return 1;
}
</%init>
</%def>



<%def .alter>
<%args>
$def
$opts
$db_defs => undef
$sql
$orig_error
$db
</%args>
<%init>

unless( $db_defs->{$1} ) {
	$m->comp( '.table_mod_error', %ARGS, error => "Field $1 is missing a definition." );
	return -1;
}
warn "Table '$opts->{table}' is missing field $1 ($db_defs->{$1})...creating it.\n";

my $alter_sql = "ALTER TABLE $opts->{table} ADD $1 $db_defs->{$1}";

unless( $db->do( $alter_sql ) ) {
	$m->comp( '.table_mod_error', %ARGS, mod_sql => $alter_sql, error => $db->errstr() );

	return -1;
} else {
	return 1;
}
</%init>
</%def>


<%def .table_mod_error>
<%args>
$sql
$mod_sql => ''
$error
$orig_error
$caller => $m->callers(2)
</%args>
<%init>
	$sql = HTML::Entities::encode( $sql );
	$mod_sql = HTML::Entities::encode( $mod_sql );
	$error =  HTML::Entities::encode( $error );
	$orig_error = HTML::Entities::encode( $orig_error );

	$m->comp( $caller->subcomps( '.error_message' ) || '.error_message', message => <<EOD );
<pre>Error in SQL: <font color=red>$orig_error</font>

	$sql

Attempting to create/alter table...

Error: <font color=red>$error</font>

	$mod_sql
</pre>
EOD
</%init>
</%def>

<%def .error_message>
<%args>
$message
</%args>
% warn "Error: $message";
<p style="margin:0;color:#f00"><% $message %></p>
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

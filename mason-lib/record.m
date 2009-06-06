<%method .title>
Database Records - Editing Forms
</%method>
<%method .doc_synopsis>
makes it trivial to edit data stored in an SQL database.
</%method>
<%method .doc>
<h2>Usage</h2>
<pre><% <<EOD
<\%init>
\$m->comp( '/record.m', \%ARGS );
</\%init>

<\%def .form>
<\%args>
\$item
\$action
</\%args>
   <h1><\% ucfirst lc \$action \%\>ing Record
   <form method=post>
      <input type=hidden name=id value=<\% \$item->{id} \%\>
      Name: <field name=name>
      Address: <field name=address> <help name="address">
      <input type=submit name=done value="Save">
    </form>
</\%def>		
<\%def .record_def>
<\%init>
return( \$m->comp( 'definition.m' ) );
</\%init>
</\%def>
EOD
 |h %></pre>

<p>The shared record-editing component provides a turnkey method of providing the 
ability to edit records in an SQL database.  By providing a record definition 
description and HTML for the record-editing form, you get control over presentation
without the effort of managing record state and other aspects of record managememnt. 
</p>

<p>The example above shows a simple form for a record with two user fields, identified by a numeric
ID in a hidden field.</p> 

<h2>Prerequisites</h2>

<p>To use the shared record-editor, you must have:</p>

<ul>
	<li><p>A Mysql database enabled for your account.</p>

	<li><p>A <a href="#record">record</a> definition.</p>

	<li><p>A <a href="#form">form</a> definition.</p>
</ul>

<a name="record"><h3>Record Definition</h3>

<p>A record definition provides field names and field types, and it also
provides options for the record in general and for specific field names.
</p>

<p>TODO: complete this</p>

<a name="form"><h3>Form Definition</h3>

<p>A form definition is a callback used by the record-editing component.  
The form definition comprises the main part of your record-editing page, 
and may include any other content in addition to a complete HTML form.
</p>

<p>When creating your form definition, you may use HTML-like tags for 
inserting form elements for your fields, according to the type of field
defined in the definition.  </p>

<pre>&lt;field name=address&gt;
&lt;field name=options&gt;</pre>

<p>Most field types need additional HTML attributes in order to be 
complete.  For example, TEXTAREA fields will want rows= and cols= and
perhaps a wrap= attribute.  TEXT fields will want size= and perhaps 
maxlength.  PULLDOWN fields do not use any attributes (MULTIPLE will
cause unexpected havoc; don't try that).  See the <code>definition</code>
documentation for more information on different field types.

<p>You may also include help links, which use the help text provided in 
the record definition's options structure ($options->{help}{field_name}).  
Simply include the field name:</p>

<pre>&lt;help name=address&gt;</pre>

<p>If the given field name does not exist, the help bubble will appear in 
red and the popup will show you the field name that's missing.</p>

<p>TODO: complete this</p>

<h2>Parameters</h2>

<p>The following arguments are recognized by the record-editing component.  
These are typically included in your form, either as hidden fields or as 
user interface elements:</p>

<ul>
	<li>TODO
</ul>

<h2>Callbacks</h2>

<P>The following callbacks offer you extra control over processing for 
different occurrences.  If the <tt>_callbacks</tt> parameter is provided, these
are called against the specified module; otherwise, they're called against the
caller of <tt>record.m</tt>. </p>

<ul>
	<li><p><b>.allow_add</b>: This callback lets you regulate the ability
	for users to add records to this table.  You can base your decision
	on any factors you wish.  $item will be provided for use in your
	decision.</p>
	
	<p>Additionally, you may change any field values provided
	in $item, ensuring positive control over the data stored in the
	record.  Returning a false value denies the add; return a true
	value allows the add to proceed.</p>

	<li><p><b>.allow_edit</b>: Allows you to regulate permissions for 
	editing records in the table, both prior to the display of an editing
	form, and prior to accepting posted changes to a record.  $item is 
	provided for use in your decision.  If a post is in progress, you will
	also receive the $orig_item. </p>

	<p>You may make any changes you wish in 
	$item, ensuring positive control over the content seen by the user
	(in the editing form) and stored in the database (when receiving a post).
	Return true or false to indicate the permission granted.
	</p>

	<li><p><b>.allow_delete</b>: Allows you to regulate permissions for
	deletes.  $item is provided for your decision-making process. Return
	true or false, to allow or deny the delete. <b>NOTE: deletions are
	disallowed by default; you MUST define this callback for deletions
	to be allowed.</b></p>

	<li><p><b>Record-Change Notifications</b>: These callbacks are provided
	after a change has been written to the database by record.m (if any
	manual or programmatic update is done without record.m, these callbacks
	are NOT triggered).  They share the same
	semantics, in that they all receive $item to indicate the record
	that received a change. </p>

	<p>Each of these callbacks allows the return of a true value (or undef) to
	indicate that the normal move-on behavior should be activated.  They
	also allow the return of a 0 (which is DEFINED and FALSE, unlike undef)
	to indicate that the normal move-on behavior should NOT be used.  This
	affords you the chance to display something the user should take action
	on.  See also the .next_url callback for specifying a delayed-redirect.</p>

	<ul>

		<li><b>.on_add</b>: Triggered after an item has been added
		to the database.  $item includes the record <b>as it was
		added to the database</b>.  </p>

		<li><p><b>.on_change</b>: Triggered after a change has been
		saved to the database by record.m.  The changed record is
		provided as $item, and the original item is provided as
		$orig_item.</p>

		<li><p><b>.on_delete</b>: Triggered after a record has been
		removed from the database by record.m.  $item is provided so
		that you know which item was already deleted. </p>

	</ul>

	<li><p><b>.next_url</b>: Called after a successful update, add, or delete
	(if the .on_* handler above didn't return 0); this callback receives $item,
	and the $next_url parameter indicates the default next url (from your
	form's 'referer' field, usually).  You may return undef if you'd like
	to handle your own redirection (say, by javascript).</p>

	<p>Other possibilities include the return of a URL to which to redirect the user
	(ensure that the url begins with 'http'), or the return of a whole or fractional
	number of seconds to delay the normal redirect.</p>

	<p>If you wish to both customize the return URL <b>and</b> specify a delayed
	redirect, the only effective way to do this is to call 
	<a href="/doc.html?module=/redir.m">/redir.m</a> directly with the URL and delay
	desired; then return undef so that record.m doesn't try to do its own (non-delayed)
	redirect.</p>
</ul>

</%method> 

<%args>
$item => {}
$action => undef
$done => undef
$id => undef
$db => undef
$DEBUG => 0
$definition => undef
$_callbacks => $m->callers(1)
</%args>

<%once> 
use Hod::DB; 
use HTTP::File; 
use HTML::Entities; 
</%once>

<%init>
unless( $action ) {
	$DEBUG && warn "record.m: no action specified; using 'edit' as default\n";
	$ARGS{action} = $action = 'edit';	
}
my( $orig_item );
my $_dbh;
my( $checkbox_fields, $regular_fields, $file_upload_fields, $date_fields );

my $caller = $_callbacks;
$caller = $m->fetch_comp($caller) unless ref( $caller );
$caller = $caller->parent_comp if( $caller->is_subcomp() );


warn "Definition: $definition" if $DEBUG > 3;
$definition &&= $m->fetch_comp( $definition ) || undef;
$definition ||= $caller->subcomps('.record_def');
die "required: .record_def component in calling component" unless( $definition );
my( $def, $opts, $db_defs ) = $m->comp( $definition );

$_dbh = $db || $dbh;  # use global database handle if not provided.

warn "--------------------- begin record.m --------------------------" if $DEBUG > 1;
warn "Args: ". Data::Dumper::DumperX( \%ARGS ) if $DEBUG > 1;
warn "Record definition: ". Data::Dumper::DumperX( $def ) if $DEBUG > 1;
warn "Record options: ". Data::Dumper::DumperX( $opts ) if $DEBUG > 1;

unless( $action eq 'add' ) {
	my $query = "SELECT * from $opts->{table} WHERE ". 
		$m->comp( '.rec_id', 
			item => \%ARGS, 
			def => $def, 
			opts => $opts, 
			db => $_dbh, 
			DEBUG => $DEBUG 
		);
	warn "fetching record: $query" if $DEBUG > 1;
	$item = $m->comp( 'db_fetch.m', query => $query, db => $_dbh );
	die( $m->comp( '.rec_id', 
		def => $def, 
		db => $_dbh, 
		opts => $opts, 
		item => \%ARGS 
	). " fetched more than one record" ) if $#$item > 0;
	$item = $item->[0];
	warn "fetched item: ". Data::Dumper::DumperX( $item ) if $DEBUG;
	return $item if $action eq 'fetch';
	$orig_item = { %$item } if $item && ref( $item ) eq 'HASH';
}

$checkbox_fields = [ grep { $def->{$_} eq CHECKBOX } keys %$def ];
$file_upload_fields = [ grep { $def->{$_} eq FILE_UPLOAD } keys %$def ];
$regular_fields = [ grep { $def->{$_} ne CHECKBOX && $def->{$_} ne FILE_UPLOAD } keys %$def ];
$date_fields = [ grep { $def->{$_} eq DATE } keys %$def ];

my $validity = $opts->{validity} || {};

warn "Storing inbound field values into record" if $DEBUG > 1;
foreach( @$regular_fields ) {
	warn "\t$_: $ARGS{$_}\n" if $DEBUG > 1;
	next unless defined $ARGS{$_};
	my $result = $m->comp('.set_value', 
		item => $item, 
		clear_error => 0,
		field => $_, 
		value => $ARGS{$_},
		def => $def,
		opts => $opts,
		caller => $caller,
		DEBUG => $DEBUG
	);
	defined $result or $ARGS{done} = $done = 0;
}

foreach( @$file_upload_fields ) {
	$item->{$_} = $ARGS{$_} if $ARGS{$_};
}
warn Data::Dumper::Dumper( $item ) if $DEBUG > 1;
if( $action eq 'add' ) {
	# on an add, we can't rely on having the right 
	# checkbox values from the database.  Get 'em
	# from the form that was posted... if applicable.
	foreach( @$checkbox_fields ) {
		$item->{$_} = $ARGS{$_} if defined $ARGS{$_};
	}
}
if( $action eq 'edit' ) {
	my $pkf = $opts->{primary};
	$pkf = [ $pkf ] unless ref( $pkf );
	foreach( @$pkf ) {
		$item->{$_} = $ARGS{"_new_$_"} if $ARGS{"_new_$_"};
	}
}
foreach( @$date_fields ) {
	$item->{$_} = '' if $item->{$_} =~ /^[-0]*$/;
}
if( $action eq 'delete' ) {
	# die "Deletion requires record identifiers" unless $m->comp( '.check_id', def => $def, opts => $opts, item => \%ARGS, DEBUG => $DEBUG );
	if( $caller->subcomps( '.allow_delete' ) 
		&& 
		! $m->comp( 
			$caller->subcomps( '.allow_delete' ), 
			item => $item
		)
	|| ( ! $session->{site_admin} && 
	  ! $caller->subcomps( '.allow_delete' ) )	
	) {
		$m->comp( $caller->subcomps( '.error_message' ) || '.error_message',
			message => 'Permission Denied'
		);
		unless( $caller->subcomps('.allow_delete') ) {
			warn( $caller->path(). " lacks .allow_delete subcomp" );
			$m->comp( $caller->subcomps( '.error_message' ) || '.error_message',
				message => '.allow_delete subcomp is now REQUIRED, to prevent unauthorized deletions'
			) if $dev;
		}
		return;
	}
	
	my $del = $m->comp( '.rec_id', 
		item => $item, 
		def => $def, 
		opts => $opts, 
		db => $_dbh,
		DEBUG => $DEBUG 
	);
	my $success;
	if( $del ) {
		$del = "delete from $opts->{table} WHERE ". $del;
		$success = $_dbh->do( $del );
	} else {
		return 0;
	}
	if( $success ) {
		my $continue = 1;
		$continue = $m->comp( $caller->subcomps( ".on_delete" ) , item => $item, args => \%ARGS ) if $caller->subcomps( '.on_delete' );
		return $success if( defined $continue && !$continue );
	}
	if( $ARGS{_im} ) {
		$m->clear_buffer();
		$r->content_type('image/gif');
		my $fn = $success ? 
			'/i/small-succeeded.gif' : 
			'/i/small-failed.gif';

 		$fn = $m->fetch_comp( $fn );
		$fn = $fn->source_file();
		$m->out( $m->file( $fn ) );
		$m->flush_buffer();
		$m->abort(301);
	} else {
		my $comp = $caller->subcomps( ".next_url" );
		my $url;
		my $delay = 0;
		my $next = $ARGS{referer} || $r->header_in('Referer') || $r->uri;
		if( $comp ) {
			$url = $m->comp( $comp, item => $item, %ARGS, next_url => $next ) if $comp;
			return $success unless defined $url;
			if( $url =~ /^http/ || $url eq 'popup' ) {
				$next = $url ;
			} else {
				$delay = $url;
			}
		}
		if( $next eq 'popup' ) {
			$m->comp('.reload_opener');
		} else {
			$m->comp('.next_url', item => $item, %ARGS, next_url => $next, delay => $delay );
		}
	}
	return $success;
} 
my $complete = $done;
if( $done ) {
	if( my $req = $opts->{required} ) {
		my $failed = 0;
		foreach my $f ( @$req ) {
			warn "Required field: $f" if $DEBUG > 1;
			unless( $item->{$f} ) {
				$failed++;
				warn " - $f not provided" if $DEBUG;
			} else {
				warn " - $f's value is: ". Data::Dumper::Dumper( $item->{$f} ) if $DEBUG > 1;
			}
		}

		if( $failed ) {
			$m->comp( $caller->subcomps( ".required_fields" ) || '.required_fields', opts => $opts, item => $item );
			$complete = 0;
		}

		if( my $validate = $opts->{validate} ) {
			foreach( @$regular_fields ) {
				my $v = $ARGS{$_};
				if( defined( $v ) ) {
					if( my $check = $validate->{$_} ) {
						local $_ = $v;
						( 
							$DEBUG > 1 && warn("Field $_: invalid value '$v'\n"),
							$m->comp( $caller->subcomps( '.error_message' ) || '.error_message',
								message => "$_: invalid value '$v'"
							),
							$complete=0,
							last 
						) unless $check->( $v );
					}
				}
			}
		}
	}
} 
if( $done && $complete ) {
	warn "Done and Complete" if $DEBUG > 2;
	if( $action eq 'edit' ) {
		warn "Storing inbound checkbox fields:\n" if $DEBUG > 1;
		foreach my $f( @$checkbox_fields ) {
			warn "\t$f\: '$ARGS{$f}'\n" if $DEBUG > 1;
			$item->{$f} = $ARGS{$f} || ' ' if( $ARGS{$f} || $ARGS{"_cb_$f"} );
		}

		if( $caller->subcomps( '.allow_edit' ) 
		&& 
			! $m->comp( 
				$caller->subcomps('.allow_edit' ), 
				item => $item, 
				orig_item => $orig_item, 
				%ARGS,
				action => $action 
			)
		) {
			$m->comp( $caller->subcomps( '.error_message' ) || '.error_message',
				message => 'Permission Denied'
			);
			return;
		} else {
			my $success;
			if( $success = $m->comp( ".save_item", %ARGS, 
				item => $item, 
				orig_item => $orig_item,
				def => $def, 
				opts => $opts, 
				db => $_dbh,
				db_defs => $db_defs,
				caller => $caller, 
				checkbox_fields => $checkbox_fields, 
				regular_fields => $regular_fields, 
				file_upload_fields => $file_upload_fields,
				DEBUG => $DEBUG 
			) ) {
				my $continue = 1;
				$continue = $m->comp( $caller->subcomps( ".on_change" ), 
					item => $item, 
					orig_item => $orig_item, 
					args => \%ARGS 
				) if $caller->subcomps( '.on_change' );
				return $success if( defined $continue && ! $continue );;

				if( $ARGS{_im} ) {
					warn "sending image for status" if $DEBUG;
					$m->clear_buffer();
					$r->content_type('image/gif');
					
					my $fn = $success ? 
						'/i/small-succeeded.gif' : 
						'/i/small-failed.gif';

					$fn = $m->fetch_comp( $fn );
					$fn = $fn->source_file();
					$m->out( $m->file( $fn ) );
					$m->flush_buffer();
					$m->abort(301);
				} else {
					my $comp = $caller->subcomps( ".next_url" );
					my $url;
					my $delay = 0;
					my $next = $ARGS{referer} || $r->header_in('Referer');
					if( $comp ) {
						$url = $m->comp( $comp, item => $item, %ARGS, next_url => $next ) if $comp;
						return $success unless defined $url;
						if( $url =~ /^http/ || $url eq 'popup' ) {
							$next = $url 
						} else {
							$delay = $url;
						}
					}
					if( $next eq 'popup' ) {
						$m->comp('.reload_opener');
					} else {
						$m->comp('.next_url', item => $item, %ARGS, next_url => $next, delay => $delay );
					}
				}
				return $success;
			} else {
				warn "Save failed" if $DEBUG;
			}
		}
	} elsif( $action eq 'add' ) {
		if( $caller->subcomps( '.allow_add' ) &&
			! $m->comp( $caller->subcomps( '.allow_add' ), item => \%ARGS ) ) {
			$m->comp( $caller->subcomps( '.error_message' ) || '.error_message',
				message => 'Permission Denied'
			);
			return;
		} else {
			if( $m->comp( ".add_new_item", 
				args => \%ARGS, 
				def => $def, 
				opts => $opts, 
				db_defs => $db_defs, 
				caller => $caller, 
				db => $_dbh,
				checkbox_fields => $checkbox_fields, 
				regular_fields => $regular_fields, 
				file_upload_fields => $file_upload_fields,
				DEBUG => $DEBUG
			) ) {
				my $pri = $opts->{primary};
				$pri = [ $pri ] unless ref( $pri );
				if( $#$pri == 0 && $def->{$pri->[0]} eq ID ) {
					my $s = $_dbh->prepare("SELECT LAST_INSERT_ID()");
					my $r = $s->execute();
					( $r ) = $s->fetchrow_array();
					$item->{$pri->[0]} = $r;
				}
				my $continue = 1;
				$continue = $m->comp( $caller->subcomps( ".on_add" ) , item => $item, orig_item => $orig_item, args => \%ARGS ) if $caller->subcomps( '.on_add' );
				warn("returning as expected with id $item->{id}"),
				return $item if ( ( defined $continue ) && ! $continue ) || $ARGS{_no_continue};

				my $comp = $caller->subcomps( ".next_url" );
				my $url;
				my $delay = 0;
				my $next = $ARGS{referer} || $r->header_in('Referer');
				if( $comp ) {
					$url = $m->comp( $comp, item => $item, %ARGS, next_url => $next ) if $comp;
					return 1 unless defined $url;
					if( $url =~ /^http/ || $url eq 'popup' ) {
						$next = $url 
					} else {
						$delay = $url;
					}
				}
				if( $next eq 'popup' ) {
					$m->comp('.reload_opener');
				} else {
					$m->comp('.next_url', item => $item, %ARGS, next_url => $next, delay => $delay );
				}
				return 1;
			} else {
				return undef if $ARGS{_no_continue};
			}
		}
	} else {
		die "Unknown action '$action'";
	}
}
if( $action eq 'edit' ) {
	if( $caller->subcomps( '.allow_edit' ) &&
		! $m->comp( $caller->subcomps('.allow_edit' ), 
			item => $item, 
			orig_item => undef, 
			%ARGS,
			action => $action 
	) ) {
		$m->comp( $caller->subcomps( '.error_message' ) || '.error_message',
			message => 'Permission Denied'
		);
		return;
	}
} elsif( $action eq 'add' ) {
	if( my $addable = $caller->subcomps( '.allow_add' ) &&
		! $m->comp( $caller->subcomps( '.allow_add' ), item => \%ARGS ) ) {
		$m->comp( $caller->subcomps( '.error_message' ) || '.error_message',
				message => 'Permission Denied'
		);
		return;
	}
}
if( my $form = $caller->subcomps( '.form' ) ) {
	my $result;
	$m->comp( $form, %ARGS, item => $item, action => $action, opts => $opts, STORE => \$result );
	warn "Item: ". Data::Dumper::Dumper( $item ) if $DEBUG > 4;
	
	# translate <field name=...> to HTML form fields
	$result =~ s/(\s+)?<field name="?(\w+)"? ?([^>]*)>/
		my $t = $m->comp( ".field_xlat", 
			item => $item,
			orig_item => $orig_item, 
			indent => $1, 
			field_name => $2, 
			attrs => $3, 
			opts => $opts, 
			def => $def, 
			action => $action, 
			done => $done, 
			DEBUG => $DEBUG 
		);
		$t
	/ige;

	# translate <help name=fieldname> to insert help for that field, if available
	$result =~ s/(\s+)?<help name="?(\w+)"? ?([^>]*)>/$1 . 
		$m->scomp( "\/help.m", name => $2, text => ( $opts->{help}{$2} ) )/ige;

	$_out->( $result );
} else {
	die("Caller must define a '.form' subcomponent for displaying the record to edit");
	
}
return;
</%init>
<%def .field_xlat>
<%args>
$item
$orig_item => {}
$field_name
$attrs
$indent
$opts
$def
$action
$done
$DEBUG => 0
</%args>
<%init>
{ my $doc = <<DOC;
Translates <field name="name" ...> to an input field appropriate
for that field name, according to the record definition, including:

	- current field value from \$item
	- the attributes ("..." above) are included in the field's HTML tag
    - appropriate indention for pretty display
DOC
}

my $req = { map { $_ => 1 } @{ $opts->{required} || [] } };
$req = $req->{$field_name} ? '<font color=red>*</font>' : '';
my $bogus_style = $done && $req && ! $item->{$field_name} 
  ? 
	'border-color:#f00;'.
	'border-style:groove;'.
	'border-right-color:#f99;border-right-width:1;'.
	'border-bottom-color:#f99;border-bottom-width:1;'
  : 
	'';

if( $bogus_style && $attrs =~ /(.*style=")(.*)/i ) {
	$attrs = "$1$bogus_style$2";
} elsif( $bogus_style ) {
	$attrs .= " style=\"$bogus_style\"";
}

warn "$done $req attrs $field_name\: $attrs" if $DEBUG > 5;

my $value = $item->{$field_name};
warn "field def is $def->{$field_name}" if $DEBUG > 4;
my $options = $opts->{$field_name};

my $field_def = $def->{$field_name};

my $rv = '';
if( $action eq 'edit' ) {
	my $pkf = $opts->{primary};
	$pkf = [ $pkf ] unless ref( $pkf );
	$pkf = { map { $_ => 1 } @$pkf };
	if( $pkf->{$field_name} ) {
		$rv = '<input type=hidden name="'.$field_name.'" value="';
			use HTML::Entities;
			$rv .= encode_entities( $value );
		$rv .= '">';
		$field_name = "_new_$field_name";
	}
}

if( ref( $options ) eq 'CODE' ) {  # item-specific options
	$options = $options->( $item, { %{ $orig_item || {} } } );
}
warn "$field_name is required" if $DEBUG > 1 && $req;

my $d = $DEBUG - 3; $d = 0 if $d < 0;
$d++ unless $field_def;
$rv .= $m->comp("/html_field.m", 
	name => $field_name, 
	value => $value, 
	def => $field_def,
	opts => $options,
	attrs => $attrs,
	indent => $indent,
	DEBUG => $d
). $req;

return $rv;
</%init>
</%def>

<%def .add_new_item>
<%args>
%args 
$def
$opts
$DEBUG => 0
$db_defs => undef
$caller
$db
$checkbox_fields
$regular_fields
$file_upload_fields
</%args>
<%init>
foreach my $f( @$checkbox_fields ) {
	$args{$f} ||= ' ';
}

my $finish = 1;
my( $field_list, $value_list );
SET_ADD_VALUES:
( $field_list, $value_list ) = ( "", "" );
foreach( @$regular_fields, @$checkbox_fields, @$file_upload_fields ) {
	my $value = $args{$_};
	next unless defined( $value );
	next if $def->{$_} eq FILE_UPLOAD && !$value;
	$value = $m->comp( '.set_value', 
		item => \%args, 
		field => $_, 
		clear_error => 1,
		abort_on_error => $args{_abort_on_error},
		value => $value, 
		def => $def,
		opts => $opts,
		caller => $caller,
		DEBUG => $DEBUG
	); defined $value or $finish=0;
	if( $value ) {
		$field_list .= "\n\t\t$_,";
		$value_list .= "\n\t\t". $db->quote($value). ",";
	}
}
return 0 unless $finish;

chop $field_list; chop $value_list;

my $val = 1;
$val = $m->comp( $caller->subcomps( '.validate' ),
	item => \%args,
	def => $def,
	opts => $opts
) if $caller->subcomps( '.validate' );

warn( "Validation failed" ), return 0 unless $val;	# if validate returned undef, don't add.
goto SET_ADD_VALUES unless $val > 0;  # if validate returned 0-but-true, redo set-values.

my $sql = "insert into $opts->{table} ( $field_list \n\t) values ( $value_list \n\t)";

my $attempts = 50;
ADD_RECORD:
--$attempts  || die "Too many attempts to successfuly fix table '$opts->{table}'";

my $result = eval{ $db->do( $sql ) }; 
if( ! $result ) {
	if( my $res = 
		$m->comp('/db_autocreate.m', %ARGS, sql => $sql, caller => $caller )
	) {
		if( $res == -1 ) {
			# they would have created/altered the table, but they couldn't because of some
			# configuration problem, or because of an sql error at create/alter time.
			#
			# they already output any appropriate error messages.
			return 0;
		} elsif( $res == 1 ) {
			# The table was created/altered succesfully;
			goto ADD_RECORD;
		} else {
			die "Unknown return from create_table or alter_table";
		}
	} else {
		warn "res is $res";
	}
	my $n = HTML::Entities::encode( $sql );
	$n =~ s/\n/<br>/g;
	$n = $m->scomp('/help.m', text => "<p>There are various possible reasons for an SQL error.  One is that the item you're trying to add already exists.</p><p>If this is a development error, this SQL may help us understand the problem:</p><pre>$n</pre><p>Ctrl-A, Ctrl-C will copy this message to the clipboard.</p>" );
	my $e = $@ || $db->errstr;
	$m->comp( $caller->subcomps( '.error_message' ) || '.error_message', message => <<EOD );
Error in SQL: <font color=red>$e</font>$n
EOD

	return 0;
}
return 1;
</%init>
</%def>

<%def .set_value>
<%args>
$item
$abort_on_error => 0
$clear_error
$field
$value => undef
$def
$opts
$caller
$DEBUG
</%args>
<%init>
my $entered_value = $value;
if( $def->{$field} =~ /^(.*)\.pm$/ ) {
	my $class = "Hod/Field/$def->{$field}";
	eval { require $class; 1 } or warn "$class not found";
	$class = "Hod::Field::$1";
	if( UNIVERSAL::can( $class, 'set_value' ) ) {
		my( $new_value, $err ) = $class->set_value( $item, $value, $opts->{$field} );
		warn "got back '$new_value' ". ($err ? "(err $err) " :"" ). "for $field set_value()" if $DEBUG > 1;
		if( ! $value && ! defined( $new_value ) ) {
			# if the field doesn't like 'empty', that's OK, we'll store it there anyway.
			$new_value = $value;
			warn "\t(ignored error from empty field)\n" if $DEBUG > 1;
		} elsif( ! defined( $new_value ) ) {
			$err ||= "Unknown error from $def->{$field}::set_value()";
			$err = "$field: $err";
			warn "\t$err";
			$m->comp( $caller->subcomps('.error_message') || '.error_message',
				message => $err
			);
			return undef if $abort_on_error;
		} else {
			$value = $new_value;
			warn "$field: $new_value" if $DEBUG;
		}
		if( $err && $clear_error ) {
			$item->{$field} = $new_value;
		} elsif( $err ) {
			$item->{$field} = $entered_value;
		} else {
			$item->{$field} = $new_value;
		}
	} else {
		warn "$field\: $class can't set_value; setting to '$value'" if $DEBUG > 1;
		$item->{$field} = $value;
	}
} else {
	warn "$field\: regular field; setting to '$value'" if $DEBUG > 1;
	$item->{$field} = $value;
}
return $value;
</%init>
</%def>


<%def .save_item>
<%args>
$def
$opts
$db
$db_defs
$item
$orig_item
$caller
$checkbox_fields
$regular_fields
$file_upload_fields
$DEBUG => 0
</%args>
<%init>
SET_EDIT_VALUES:
my $value_settings = '';
my $finish = 1;
warn "setting field values in preparation for saving" if( $DEBUG > 1 );
foreach( @$regular_fields, @$checkbox_fields, @$file_upload_fields ) {
	warn "\t$_\: $item->{$_}\n" if $DEBUG > 1;	
	my $value = $item->{$_};
	next if $def->{$_} eq FILE_UPLOAD && !$value;
	$value = $m->comp( '.set_value', 
		item => $item,
		field => $_, 
		clear_error => 1,
		value => $value, 
		def => $def,
		db => $db,
		opts => $opts,
		caller => $caller,
		DEBUG => $DEBUG
	) or $finish=0;
	$value_settings .= "\n\t\t\t" if $value_settings;
	$value_settings .= "$_=".$db->quote($value). ",";
}
chop $value_settings;

my $val = 1;
$val = $m->comp( $caller->subcomps( '.validate' ),
	item => $item,
	orig_item => $orig_item,
	def => $def,
	opts => $opts
) if $caller->subcomps( '.validate' );

warn( "validation failed" ), return 0 unless $val;	# if validate returned undef, don't add.
goto SET_EDIT_VALUES unless $val > 0;  # if validate returned 0-but-true, redo set-values.


my $rec_id = $m->comp( '.rec_id', 
	def => $def, 
	opts => $opts, 
	item => $orig_item,
	db => $db,
);
my $sql = <<EOD;
	Update $opts->{table} 
		set $value_settings 
		where $rec_id
EOD

warn $sql if $DEBUG;
my $attempts = 50;
SAVE_RECORD:
--$attempts  || die "Too many attempts to successfully fix table '$opts->{table}'";
my $result = eval { $db->do( $sql ) };
if( ! $result ) {
	if( my $res = 
		$m->comp('/db_autocreate.m', %ARGS, 
			sql => $sql, 
			dbh => $db, 
			caller => $caller 
		)
	) {
		if( $res == -1 ) {
			# they would have created/altered the table, but they couldn't because of some
			# configuration problem, or because of an sql error at create/alter time.
			#
			# they already output any appropriate error messages.
			return 0;
		} elsif( $res == 1 ) {
			# The table was created/altered succesfully;
			goto SAVE_RECORD;
		} else {
			die "Unknown return from create_table or alter_table";
		}
	} else {
		warn "res is $res";
	}
	my $n = HTML::Entities::encode( $sql );
	my $e = $@ || $db->errstr;
	$m->comp( $caller->subcomps( '.error_message' ) || '.error_message', message => <<EOD );
<pre>Error in SQL: <font color=red>$e</font>

	$n
</pre>
EOD

	return 0;
}
return $result;
</%init>
<% $sql %>
</%def>

<%def .rec_id>
<%args>
$item
$def
$opts
$db
$DEBUG => 0
</%args>
<%init>
my $primary = $opts->{primary};
my $table = $opts->{table} || 'unknown table';
die( "Development error: definition options for $table require 'primary' entry" )
	unless $primary;
$primary = [ $primary ] unless ref( $primary ) eq 'ARRAY';
warn "    Primary key fields: ". join( ",", @$primary ) if $DEBUG > 2;
my $sql = join( ' AND ', map { "$_=". $db->quote( $item->{$_} ) } @$primary );
warn "id: $sql" if $DEBUG;
return $sql;
</%init>
</%def>


<%def .next_url>
<%args>
$next_url
$delay => 0
</%args>
% my @when = $delay ? ( delay => $delay ) : ( immediate => 1 );
<p><a href="<% $next_url %>">Keep working</a></p>
% $m->comp( '/redir.m', url => $next_url, @when );
</%def>

<%def .required_fields>
<%args>
$item
$opts
</%args>
<p><font color=red>Required Fields:</font> The marked fields must be provided!</p>
</%def>

<%def .error_message>
<%args>
$message
</%args>
% warn "Error: $message";
<p style="margin:0;color:#f00;font-weight:bold"><% $message %></p>
</%def>


<%def .reload_opener>
<h2>Changes Saved</h2>

<script language=javascript>
<!--
var reload_timeout;
var reload_time = 4;
var cancel_button = '';
var reload_button = '<input type=submit name=rel value="Close &amp; Reload Parent" onClick="reload_doit()">';

function reload_doit() {
	if( window.opener ) { 
		if( ! window.opener.closed ) {
			window.opener.location.reload(true);
			window.close();
		}
	} else {
		alert( "Error: 'popup' specified for referer, but this window was not a popup" );
	}
}

function reload_tryit () {
	reload_time = reload_time - 1;
	document.forms['reload_form'].rel.value="Closing Popup in "+ reload_time+"...";
	if( reload_time > 1 ) {
		reload_timeout = setTimeout( "reload_tryit()", 1000 );
	} else {
		reload_timeout = setTimeout("reload_doit()", 1000 );
	}
}
if( window.opener ) {
	if( window.opener.closed ) {
		document.write( "<b>Note: parent window was closed.  Not automatically closing this popup.</b>" );
	} else {
		document.write( "Reloading Parent Window..." );
		reload_timeout = setTimeout("reload_tryit()", 1 );
		cancel_button = '<input type=submit value="Cancel" onClick="clearTimeout(reload_timeout);this.form.rel.value=\'Close &amp; Refresh Parent\';this.disabled=1;return false;">';
	}
} else {
	document.write("<b>Note: No parent window, so this is not a popup.  Not automatically closing this window.</b>");
% if( $dev ) {
	alert( "Development Error: $ARGS{referer} = 'popup', but this window was not popped up!" );
% }
}

//-->
</script>
<form name="reload_form">
<script language=javascript>
<!--
document.write(cancel_button);
if( window.opener && ! window.opener.closed ) document.write(reload_button);
//-->
</script>
<input type=submit onClick="window.close()" value="Close (no reload)">
</form>
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

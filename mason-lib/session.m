<%flags>
inherit => undef
</%flags>
<%method .title>
Persistent Per-User Sessions
</%method>
<%method .doc_synopsis>
Use a cookie to establish server-side storage of (possibly complex) per-user session details.  
Also can save/fetch form values to ease use of persistent forms.
</%method>
<%method .doc>
<h2>Usage</h2>
<p>This module uses cookies to fetch an existing session or establish a
new session.  </p>

<p>When you call this module without any parameters, either the
session is fetched or it is created (if the cookie exists), or
the cookie is sent to the user's browser. 
</p>

<p>The session that is fetched can be found in the global $session, which is 
a hashref.  The session can use arbitrary complexity for its data storage 
(see the perldoc for Data::Dumper).</p>

<h2>Behavior</h2>

<p>When the cookie is sent, a redirect is sent to 
<a href="/doc.html?module=/cookie_check.html">/cookie_check.html</a> with 
the URL that's being requested; it ensures that the cookie is properly set,
and then it sends the user back to the URL that is trying to be served.  
Remember, this only occurs when the cookie is not yet set in the user's 
browser.</p>

<p>You may override the cookie-check URL.  See below for more information on usage of
parameters.</p>

<p>If you wish to initiate optional session-management for users who accept cookies,
use the <code>skip_cookie_check</code> parameter - the cookie will be set but not 
forced.</p>

<p>The session data is stored in the site-wide database ($dbh) if available.  If the
table does not exist, it is created automatically. If the database ($dbh) does not
exist, the session is stored in the filesystem under the mason-data directory.  For
performance purposes, we recommend using the database exclusively. </p>

<p>For porting purposes, any sessions found in the filesystem will be converted to
the database, leaving the filesystem-based session intact for the time being.  
After the standard period of inactivity (the database will have any activity 
instead of the filesystem), the filesystem-based session will be removed 
automatically.  </p>

<h2>Options and Customizing</h2>

<p>Custom settings for session management can be set for your website by creating
a file <code>/session/settings.m</code> in your web site.  This module will read
your settings and act on them.  Currently available settings:</p>

<ul>

	<li><b>fields</b>: a hashref of field names to field types.  In addition to the 
	'referer' field which normally stores the website that originally referred the
	visitor, other fields can be specified here.  These fields will be automatically
	created with the specified SQL field type, and the settings saved in this field 
	will be maintained separately from the generic data structure.  For example:

<pre><% <<EOD
<\%init>
return {
	fields => {
		first_name => 'varchar(25)',
	},
}:
</\%init>
EOD
  |h %></pre>

	<p><b>NOTE</b>: Field definitions are used for creation only; if you wish to change
	the definition, we suggest modifying the table using the SQL command-line interface.</p>
</ul>

<h2>Caveats</h2>

<h3>Forms Posting to Session-Setting Pages</h3>
<p>This modules uses /cookie_check.html to perform a test that the
cookie-set was successful.  For best operation, we recommnd that the
use of &lt;form method=POST&gt; be limited to pages where you know that the
session cookie is already set.  &lt;form method=GET&gt; is perfectly 
acceptable, or your sessions can be initially set on a page that's 
not the result of a form submission.
</p><p>
See caveats in <a href="/doc.html?module=/cookie_check.html">/cookie_check.html</a>.
</p>

<h3>Using Sessions from a Site-Wide Autohandler</h3>

<p>If you use sessions from a site-wide autohandler, the cookie-check page will 
be wrapped with the autohandler's content.  The cookie-check page is marked such
that the session module will not try to set cookies while that page is being served.
For other pages you wish to be accessible without cookies, define the following 
method:

<pre><% <<EOD
<\%method .session_no_cookie_required>
</\%method>
EOD
 |h %></pre>

<p><b>WARNING:</b> Do not attempt to use this setting in the autohandler
itself.  If you do so, the session cookie will never be set.</p>

<p>Note that <a href="/doc.html?module=/privacy_template.html">the privacy template</a>
and the <a href="/doc.html?module=security_template.html">the security template</a>
already define the method above, so it's not necessary for you to re-define it for 
your <code>privacy_policy.html</code> and <code>security_statement.html</code>.</p>

<h2>Parameters</h2>

<p>The following parameters can be used to alter the behavior
described above or access additional features of this module:</p>
<ul>
	<li><p><b>id</b>: By providing a session id, the cookie-setting behavior
	described above is bypassed.  </p>

	<li><P><b>secure</b>: If true, the session is only fetched if https is 
	being used.</p>

	<li><P><b>skip_cookie_check</b>: If true, then the cookie-checking is not
	performed.  This allows the setting of a cookie for clients who will take
	it, while not requiring the cookie to be set.  </p>

	<li><P><b>no_cookie_required</b>: If true, then no cookie is set, and no
	$session will be made available.  However, if a cookie has been provided,
	$session will be made available.
	</p>

	<li><p><b>cookie_check_url</b>: If provided, this URL is used instead of
	the default <code>/cookie_check.html</code>.  This URL should be relative 
	to your server root.  This file will receive the following parameters:</p>

	<ul>

		<li><p><b>referer</b>: The referer, who might be a page within this site,
			or might be a search engine or advertising provider.</p>

		<li><p><b>cookie</b>: The name of the cookie being checked - 'session'.</p>

		<li><p><b>url</b>: The URL originally requested.</p>

	</ul>

	<li><p><b>args</b>: A hashref to a list of arguments, usually the %ARGS 
	used in your module for accessing the URL parameters.  Used by save and 
	fetch for keeping persistent form data.</p>

	<li><p><b>save</b>: Without 'args' provided, a true value causes the
	session to be saved to disk immediately.</p>
	<p>With 'args' provided, 'save' should be an
	arrayref of field names to store in the
	session (uses 'location' if provided).  Any fields with names 
	defined are saved to the session location, even if empty (so 
	that a user can clear a field's value and have that saved 
	properly).  

	<p>Example: Save the session to disk:</p>
<pre>
&lt;&amp; /session.m, save =&gt; 1 &amp;&gt;
</pre>
	<p>Example: Store fields from the just-posted form into the session:</P>
<pre>
&lt;&amp; /session.m, 
    save =&gt; [ 
        qw(name address1 address2 
        city state zip) 
    ],
    args =&gt; \%ARGS
&amp;&gt;
</pre>

	<li><p><b>fetch</b>: An arrayref of field names to fetch from the session, if 
	not already provided in the 'args' hashref.  Used for persisting data between
	the session and a form, any arguments not provided in the 'args' hashref are 
	filled in from the session.  Note that the session is <i>not modified</i> by 
	this operation.  Use 'save' for that.</p>

	<li><p><b>location</b>: A hashref, defaults to the global $session but can be set to 
	be a subtree of the session, or can technically be distinct from the $session.  Used
	by 'save' (with args) and 'fetch' operations.</p>

	<li><p><b>empty_fields</b>: An arrayref that's filled with a list of fields which are 
	found to be empty during a 'save' operation.</p>
</ul>

</%method>
<%shared>
my $base;
my $session_path;
my $incoming_refresh_interval;
my $cookie_lifetime;
my %cookies;
my $use_secure;
my $secret = 'secret23c29829j23kfnodijefjiefwfwofjjscxm37wiowejoiw9823923kjnefWjwoiwjf(*@HJ(#*hj#@332';

$base = $m->interp->data_dir() . "/session";

use Digest::SHA1 qw(sha1_base64);

use File::Find;

use Data::Dumper;

use Apache;
use Apache::Constants ':response';

use CGI qw(url https);
use CGI::Cookie;
my $cookies = $r->header_in('Cookie');
%cookies = CGI::Cookie->parse( $cookies );
warn Data::Dumper::Dumper( \%cookies ) if $_DEBUG > 1;
if( $use_secure ) { 
	warn "gotta be secure!" if $_DEBUG; 
	return 0 unless https(); 
	warn "it's secure, good." if $_DEBUG; 
}

</%shared>
<%init>
$use_secure = $secure;
$_DEBUG = $DEBUG;

my %h = $r->headers_in();
warn Data::Dumper::Dumper( \%h ) if $_DEBUG > 1;


$cookie_lifetime = $m->comp('.cookie_lifetime');
my $extend = $cookie_lifetime / 2;          # after how long will we extend the cookie?
my $cookie_expire = "+${cookie_lifetime}s"; # useful to CGI::Cookie - the number of seconds

my $session_cookie = $cookies{session}->value() if defined $cookies{session};
my $session;  # local version of the actual session hash
my $session_name; # local version of the session ID
my $bad_session_name; # bad session id generated by an earlier off-by-one bug
my $icky_session_name; # icky session id having a 0.123456 random number at the end :(

if( exists $ARGS{location} ) {
	die "must initialize 'location' parameter to a hashref"
	unless defined $ARGS{location};
}

my $cookie; 

my $scook = $cookies{impersonate} || $cookies{session};

if( $id ) {
	$session_name = $id;
	warn "using id: $session_name" if $_DEBUG > 1
} elsif( $scook && $scook->value() ) {
	$session_cookie = $scook->value();

	warn "Session cookie is $session_cookie" if $_DEBUG > 1;

	my $hash = substr( $session_cookie, 0, 27 );
	$bad_session_name = substr( $session_cookie, 29 ) || die "error: no session found in cookie: $session_cookie";
	$session_name = substr( $session_cookie, 28 ) || die "error: no session found in cookie: $session_cookie";

	warn "hash $hash, session_name $session_name" if $_DEBUG > 1;

	$bad_session_name =~ s/(.*)-refresh.*/$1/;
	# ??? icky bogus stuff
	$icky_session_name = $session_name;
	$icky_session_name =~ s/-refresh-.*//;
	$session_name =~ s/0\.\d+//;
	# /// icky bogus stuff

	$session_name =~ s/-(temp|refresh).*//;  # leaves us with just the session id.

	# ensure that the hash in the cookie was generated by us.
	# ensure that the session ID has only numerics and "-"'s.
	unless( $hash eq sha1_base64( $secret. $session_name ) && $session_name =~ /^[-0-9]+$/ ) {
		warn "hash $hash doesn't match hash for $session_name" if $_DEBUG;
		unless( open FAILURES, "$base/FAILURES" ) {
			open FAILURES, "> ". "$base/FAILURES"
				or return "";
			print FAILURES "Bogus cookie from IP address ". $r->connection->remote_ip(). ": $session_cookie\n";
			close FAILURES;
			return "";
		}
	}
	warn "using cookie: $session_name" if $_DEBUG > 1;
} else {
	# There was no cookie, so we need to set one.

	if( $m->base_comp->method_exists('.session_no_cookie_required') ||
		( $m->callers(1) && $m->callers(1)->method_exists('.session_no_cookie_required') ) ||
		$no_cookie_required
	) {
		warn("No cookie, but then, none is required.  Not sending a cookie...\n") if $_DEBUG;
		$m->interp->set_global( '$session' => {} );
		$session_id = -99999999;
		$session_timestamp = -999999999;
		return 0;
	}

	# Use random number, such that duplicates are unlikely 
	# - on the order of 10 million to one.
	my $id = time() . "-". int(rand()*10000000);

	# set the cookie:

	$m->comp('.set_session_cookie', 
		id => $id, 
		%ARGS,
		( $cookies{pubterm} ? ( temp => 1 ) : () )
	);
	return 0;
}
# if we get here, there's definitely a session ID to be had.

$session_path = "$base/$session_name";
my $bad_session_path = "$base/$bad_session_name";

unless( $save || $fetch ) {

# clean up old sessions.
# !!! do this only once an hour, and do it at the end of a request, not at the beginning.

	find( sub {
		# changed timeout to one month for jfpaint. JS 20010731
		return if /^FAILURES$/;
		my $time = ( stat( $_ ) )[9];
		if( time() - $time > 23 * 24 * 60 * 60 ) {
			# remove sessions > 23 days old
			unlink $File::Find::name;
		}
	}, $base );

	warn( "$session_name ($session_id) timestamps: $session_timestamp, ". $m->comp('.timestamp', $session_name) )
		if $_DEBUG > 1;

	unless( defined $HTML::Mason::Commands::session && 
		$session_id eq $session_name &&
		$session_timestamp == ( $m->comp('.timestamp', $session_name ) )
	) {
		warn "fetching session $session_name" if $_DEBUG;
	 	my $t_session;
		unless( defined( 
			$t_session = ( 
				$m->comp( '.db_get',   $session_name )       ||
				$m->comp( '.db_get',   $icky_session_name )  ||
				$m->comp( '.file_get', $session_path )       ||
				$m->comp( '.file_get', $bad_session_path )
			) 
		) ) {
			$session_timestamp = $m->comp('.db_create', $session_name ) || $m->comp('.file_create', $session_path );
		}

		if( ref( $t_session ) eq 'HASH' ) {
		 	$session = $t_session->{data};
			$session_timestamp = $t_session->{tstamp};
		} else {
			$session = $t_session;
			$session_timestamp = ( stat( $session_path ) )[9];
		}
		use Carp qw(confess);
		{ 
			local $SIG{__DIE__} = sub { confess() };
			$session = eval "no strict 'vars'; $session"; 
		}
		die $@ if $@;
		$session ||= { };

		if( ref( $t_session ) eq 'HASH' ) {
			# $_DEBUG += 3;
			warn "Inserting separate fields from database: \n" if $_DEBUG > 1;
			my $fields = $m->comp('.db_fields');
			warn Data::Dumper::Dumper( $fields, $t_session ) if $_DEBUG > 2;
			foreach my $f( keys %$fields ) {
				warn "\tfield: $f = $t_session->{$f}\n" if $_DEBUG > 1;
				$session->{$f} = $t_session->{$f} if defined $t_session->{$f};
			}
			$session->{_id} = $session_name;
			# warn Data::Dumper::Dumper( $session );
			# $_DEBUG -= 3;
			# sleep 5;
			
		}

		$HTML::Mason::Commands::session = $session;
		$m->interp->set_global( '$session' => $session );
		$session_id = $session_name;

		warn "new ts for $session_name\: $session_timestamp" if $_DEBUG > 1;
		if( ! exists $session->{referer} ) {
			$session->{referer} = $m->top_args->{referer};
			$m->comp('/session.m', save => 1 );
		}
	} else {
		warn "recycling existing session $session_id" if $_DEBUG;
		$session = $HTML::Mason::Commands::session;
	}

	$incoming_refresh_interval = $session->{cookie_lifetime} || $cookie_lifetime;
	$m->comp('.verify_cookies', session => $session ) unless $m->base_comp->method_exists('skip_cookie_verify');
	warn "session is $session" if $_DEBUG > 2;
	return $session;
} else {
	my $failed = undef;
	if( $args ) {
		$location ||= $HTML::Mason::Commands::session;
		if( $save ) {
			$m->comp( '.failed' ) unless ref( $save ) eq 'ARRAY';
			warn "saving args..." if $_DEBUG;
			warn Data::Dumper::Dumper( $args ) if $_DEBUG > 2;
			foreach( @$save ) {
				defined $args->{$_} or $args->{$_} = $location->{$_};
				my $msg = "    $_ => $location->{$_}" if $_DEBUG > 1;
 				unless( $args->{$_} ) {
					$failed = 1;
					push @$empty_fields, $_ if $empty_fields;
					$msg .= " (empty!)";
				}
				warn "$msg\n" if $_DEBUG > 1;
				$location->{$_} = $args->{$_};
			}
			$failed ||= 0;	
		} elsif( $fetch ) {
			$m->comp( '.failed' ) unless ref( $fetch ) eq 'ARRAY';
			warn "fetching fields: ". join( ", ", @$fetch ) if $_DEBUG;
			warn Data::Dumper::Dumper( $args ) if $_DEBUG > 2;
			foreach( @$fetch ) {
				my $how;
				if( defined $args->{$_} ) {
					$how = "posted";
				} else {
					$how = "from session";
					$args->{$_} = $location->{$_};
				}
				warn "    $_ => $location->{$_} ($how)\n" if $_DEBUG > 1;
			}
			warn "done fetching." if $_DEBUG > 1;
		} else {
			$m->comp( '.failed' );
		}
	} 
	if( $save )  {
		unless( $HTML::Mason::Commands::session ) {
			warn( "Session abandoned" ) if $_DEBUG;
			return undef;
		}

		my $freeze = sub {
			my $data = shift || $HTML::Mason::Commands::session;
			local $Data::Dumper::Indent = 1; 
			return Data::Dumper::Dumper( $data );
		};

		warn( "saving session $session_name" ) if $_DEBUG;
		warn( "Session $HTML::Mason::Commands::session = ". Data::Dumper::Dumper( $HTML::Mason::Commands::session ) )
			if $_DEBUG > 2;

		$session_timestamp = 
			$m->comp('.db_put', $freeze, $session_name )    ||
			$m->comp('.file_put', $freeze, $session_path );

		warn "new ts for $session_name\: $session_timestamp" if $_DEBUG > 1;
	}
	if( defined $failed ) {
		return undef if $failed;
		return 1;
	} 
}
return "";
</%init>
<%def .failed>
session.m:<br>
 'save' or 'fetch' parameter must be a reference to a field-name list.<br>
 'args' parameter must be a reference to a hash of field values to save (or fetch).<br>
 'location' parameter is an optional reference to a hash within $HTML::Mason::Commands::session
where args will be saved or fetched.<br>
<br>
NOTE: 'fetch' will not replace values in $ARGS - it simply fetches any that are UNDEFINED.  To get the
current contents of all the specified fields in a session, pass an empty hashref for $args.

</%def>

<%def .timestamp>
<%init>
return 
	( $m->comp( '.db_get', $_[0] ) || {} )->{tstamp} ||
	( stat( $session_path ) )[9];
</%init>
</%def>


<%def .file_get>
<%init>
warn "fetching session from file" if $_DEBUG;
open SESSION, "<$_[0]";
my $session;
local $/ = undef;
$session = <SESSION>;
warn "session is: $session" if $_DEBUG > 2;
close SESSION;
return $session;
</%init>
</%def>

<%def .file_create>
<%init>
warn "$_[0] does not exist.  Creating..." if $_DEBUG;
open SESSION, ">$_[0]"
 	or die "couldn't create session file ($!): $_[0]";
return ( stat( $_[0] ) )[9];
</%init>
</%def>

<%def .file_put>
<%init>
 -d $base or die "Development error: $base does not exist";
 warn "storing in file" if $_DEBUG;
 open SESSION, ">$_[1]"
	or die "couldn't open session file for write ($!): $_[1]";

 print SESSION $_[0]->( $session );

 close SESSION;

 return( ( stat( $_[1] ) )[9] );
</%init>
</%def>



<%def .db_get>
<%init>
return undef unless $dbh;
warn "fetching session $_[0] from database" if $_DEBUG > 1;
 
my $s; $s = $dbh->prepare( "SELECT * from session where id='$_[0]'" );
unless( $s->execute() ) {
	if( my $res = $m->comp('/db_autocreate.m',
		def => '/session/definition.m',
		sql => $s
	) ) {
		if( $res == -1 ) {
			warn( "Session create failed: ". $dbh->errstr() . "\n");
			return undef;
		}
		return $m->comp('.db_get', @_ );
	} else {
		warn "Session: couldn't fetch $_[0] from database";
		return undef;
	}
	return undef;
}
my $r = $s->fetchrow_hashref();
# warn Data::Dumper::Dumper( $r ) if $_DEBUG;
return $r;
</%init>
</%def>


<%def .db_create>
<%init>
return undef unless $dbh;
warn "creating in database" if $_DEBUG > 1;
my $sql = "REPLACE INTO session(id) values ( '$_[0]' )";
unless( $dbh->do( $sql ) ) {
	if( my $res = $m->comp('/db_autocreate.m',
		def => '/session/definition.m',
		sql => $sql
	) ) {
		if( $res == -1 ) {
			warn( "Session create failed: ". $dbh->errstr() . "\n");
			return undef;
		}
		return $m->comp('.db_create', @_ );
	} else {
		warn( "Session create failed: ". $dbh->errstr() . "\n");
		return undef;
	}
} 
my $st; $st = $dbh->prepare( "SELECT tstamp from session where id='$_[0]'" );
unless( $st->execute() ) {
	warn "Session: couldn't fetch $_[0] from database: ". $dbh->errstr();
	return undef;
}
my $r = $st->fetchrow_hashref();
return $r->{tstamp};
</%init>
</%def>

<%def .db_put>
<%init>
return undef unless $dbh;
warn "Storing in database" if $_DEBUG;
my $freeze = $_[0];
my $separate_fields = $m->comp( '.db_fields' );
my $field_list = "id, data";
my $t_session = { %$session };
my @separate_values = ();
warn "Saving separate fields into database..." if $_DEBUG > 1;
my $f = $m->comp('.db_fields');
foreach( keys %$separate_fields ) {
	my $t = ref( $session->{$_} ) ? undef : delete $t_session->{$_};
	if( $f->{ $_ } =~ /^(.*)\.pm$/ ) {
		my $class = "Hod/Field/$f->{$_}";
		eval { require $class; 1 } or warn "$class not found";
		$class = "Hod::Field::$1";
		if( UNIVERSAL::can( $class, 'set_value' ) ) {
			my( $new_value, $err ) = $class->set_value( undef, $t );
			if( ! $t && ! defined( $new_value ) ) {
				# if the field doesn't like 'empty', that's OK, we'll use it anyway
				$t = $t;
			} elsif( ! defined( $new_value ) ) {
				$err ||= "Unknown error from $f->{$_}::set_value()";
				$err = "$_: $err";
				die "\t$err";
			} else {
				$t = $new_value;
			}
		}
	}

	warn "Separate field: $_ = $t\n" if $_DEBUG > 2;
	
	next if $_ eq 'data' || $_ eq 'id';
	$field_list .= ",$_";
	push @separate_values, $t;
}
delete $t_session->{_id};
warn Data::Dumper::Dumper( $t_session ) if $_DEBUG > 2;
my $values = join ",", map { defined $_ ? $dbh->quote( $_ ) : "NULL" } $_[1], $freeze->( $t_session ), @separate_values;
my $sql = "REPLACE INTO session( $field_list ) values ( $values )";
warn "  SQL: $sql\n" if $_DEBUG > 3;
unless( $dbh->do( $sql ) ) {
	if( $m->comp('/db_autocreate.m', 
		def => '/session/definition.m',
		sql => $sql
	) ) {
		return $m->comp('.db_put', @_ );
	} else {
		warn "Couldn't save session to database: ". $dbh->errstr;
		return undef;
	}
}
warn "Fetching $_[1] timestamp from database" if $_DEBUG > 1;
my $s; $s = $dbh->prepare( "SELECT tstamp from session where id='$_[1]'" );
unless( $s->execute() ) {
	warn "Session: couldn't fetch $_[1] from database: ". $dbh->errstr();
	return undef;
}
my $r = $s->fetchrow_hashref();
return $r->{tstamp};
</%init>
</%def>

<%def .db_fields>
<%init>
my( $f,$o,$d ) = $m->comp('/session/definition.m');
delete $f->{tstamp};
return $f;
</%init>
</%def>

<%once>
my $_DEBUG;
</%once>

<%args>
$save => undef
$fetch => undef
$secure => undef
$args => undef
$cookie_check_url => '/cookie_check.html'
$skip_cookie_check => 0
$location => undef
$empty_fields => undef
$id => undef
$no_cookie_required => 0
$DEBUG => 0
</%args>

<%def .verify_cookies>
<%args>
$session => {}
$remember_me => undef
</%args>
<%init>

	# $remember_me is used by /session/register.html to indicate the user's
	# preference regarding being remembered.  ONLY in the case where that module
	# is being used, does this setting come into play.
	
	my $cookies = $r->header_in('Cookie');
	my %cookies = CGI::Cookie->parse( $cookies );

	my $session_cookie = $cookies{impersonate} || $cookies{session} ;
	$session_cookie &&= $session_cookie->value();

	my $session_name = substr( $session_cookie, 28 );

	my $expire = ( $session || {} )->{refresh_interval};
	warn "---- session's refresh interval? ". ( $session->{refresh_interval} ? "yes":"no" ). "\n" if $_DEBUG > 1;
	$expire ||= $m->comp('.cookie_lifetime');

	my $extend = $expire/2;
	my $cookie_expire = "+${expire}s";

	warn "session name: '$session_name'\n" if $_DEBUG;

	# when to refresh? after refresh time is expired
	if( ( $session_name =~ s/(.*)-((temp)|refresh-(\d+))$/$1/ && $4 && ( $4 < time() ) ) ||

		# or if no cookie exists
		( ! $cookies{session} || ! $session_name ) ||

		# or if stored refresh interval has changed.
		( $expire != $incoming_refresh_interval && ! $3 ) ||

		# or if they were on temp-cookie and they've switched to perm
		( $3 && $remember_me )
	) {
		# refresh cookie
		warn time(). ": extending cookie from $4 to ". ( time() + $extend ) ."\n" if $_DEBUG;

		warn "expire: $expire, incoming-refresh_interval: $incoming_refresh_interval" if $_DEBUG > 1;

		$session_cookie =~ s/-(refresh-|temp).*/-refresh-/;

		# ??? icky bogus stuff 
		$session_cookie =~ s/0\.\d+(-refresh-)/$1/;  # get rid of bogus part of session-id
		# /// icky bogus stuff

		$session_cookie .= ( time() + $extend );
		warn "   ( cookie = $session_cookie )\n" if $_DEBUG > 1;
		my $cookie = CGI::Cookie->new( 
			-name => 'session', 
			-value => $session_cookie, 
			-path => '/', 
			-secure => $use_secure, 
			-expires => $cookie_expire
		);
		$r->cgi_header_out('Set-Cookie', $cookie->as_string );
		warn "extending cookie lifetime: ". $cookie->as_string if $_DEBUG;

		if( $remember_me && $cookies{pubterm} ) {
			warn "Unsetting pubterm cookie..." if $_DEBUG > 1;
			my $cookie = CGI::Cookie->new(
				-name => 'pubterm',
				-value => 'deleting',
				-path => '/',
				-expires => "-600d"
			);
			$r->cgi_header_out('Set-Cookie', $cookie->as_string );
		}
	} elsif( ! $3 && defined $remember_me && ! $remember_me ) {
		# it's a permanent cookie, but dont-remember-me was requested.
		warn "Setting pubterm cookie..." if $_DEBUG > 1;
		my $cookie = CGI::Cookie->new(
			-name => 'pubterm',
			-value => '1',
			-path => '/',
			-expires => "+600d"
		);
		$r->cgi_header_out('Set-Cookie', $cookie->as_string );

		warn "Changing session-cookie to temporary..." if $_DEBUG > 1;
		$session_cookie =~ s/-(refresh-|temp).*/-temp/;
		$cookie = CGI::Cookie->new( 
			-name => 'session', 
			-value => $session_cookie, 
			-path => '/', 
			-secure => $use_secure, 
		);
		$r->cgi_header_out('Set-Cookie', $cookie->as_string );
	} elsif( $3 ) {
		warn "================= Temp cookie ====================\n" if $_DEBUG;
	} else {
		warn "refresh time on the cookie is $4, ".  sprintf( "%.4f", ( $4 - time() ) / ( 60*60*24 ) ) . " days from now\n" if $_DEBUG > 1;
	}
	return undef;
</%init>
</%def>

<%def .cookie_lifetime>
<%init>
	# !!! make this cache cookie lifetimes so it doesn't have to do a lookup each time?

 	# figure out how long a cookie lifetime to use.
	my $s = $m->fetch_comp('/session/options.m');  # check for site options
	$s &&= $m->comp( $s );
	$s &&= $s->{cookie_lifetime};  # check for custom cookie lifetime
	my $life;
	if( $s ) {
		$life = $s;
	} else {
		$life = 30 * 24*60*60
	}
	return $life;
</%init>
</%def>


<%def .set_session_cookie>
<%args>
$id
$use_secure => 0
$cookie_check_url => '/cookie_check.html'
$skip_cookie_check => 0
$next_url => ''
$temp => 0
$impersonate => 0
</%args>
<%init>
	my $expire = ( $session || {} )->{refresh_interval};
	warn "---- session's refresh interval? ". ( $session->{refresh_interval} ? "yes":"no" ). "\n" if $_DEBUG > 1;
	$expire ||= $m->comp('.cookie_lifetime');

	my $extend = $expire/2;
	my $cookie_expire = "+${expire}s";

	warn "------------------- this is a temp cookie -------------------" if $temp && $_DEBUG > 1;

	# add a hash to secure the session cookie:
	my $value = sha1_base64( $secret . $id ) ."-". $id;
	if( $temp ) {
		$value .= '-temp';
	} else {
		$value .= "-refresh-". ( time()+ $extend );
	}
	my $cookie_name = "session";
	$cookie_name = 'impersonate' if $impersonate;

	if( $cookies{$cookie_name} ) {
		# delete any existing session cookie.
		my $delcookie = CGI::Cookie->new(
			-name => $cookie_name,
			-value => 'deleted',
			-path => '/',
			-expires => '-365d'
		);
		$r->cgi_header_out('Set-Cookie', $delcookie->as_string );
	}

	my $cookie = CGI::Cookie->new( 
		-name => $cookie_name,
		-value => $value, 
		-path => '/', 
		-secure => $use_secure, 
		( $temp ? () : ( -expires => $cookie_expire ) )
	);

	unless( $next_url ) {
		$next_url = url( -path_info => 1, -query => 1, -absolute => 1 );
		$next_url =~ s/\.html\//\.html/;
	}
	$next_url = CGI::escape( $next_url );

	my $ref = $m->top_args->{referer} || $r->header_in('Referer');
	while( $ref =~ /.*\/cookie_check.html?(.*)/ ) {
		my $t = $1;
		my $q = new CGI( $ref );
		$ref = $q->param('referer') if defined $q->param('referer');
	}
	$ref = CGI::escape( $ref );

	$cookie_check_url .= "&" if $cookie_check_url =~ /\?/;
	$cookie_check_url .= "?" if $cookie_check_url !~ /\?/;

	my $url = "${cookie_check_url}cookie=session&url=$next_url&referer=$ref";

	warn "Setting cookie: $cookie" if $_DEBUG;

	$r->cgi_header_out('Set-Cookie', $cookie->as_string );

	if( $skip_cookie_check ) {
		warn( "no cookie is being forced; if they take the cookie, then great!\n" ) if $_DEBUG;
		return;
	}

	warn "Checking for newly-set cookie using $url" if $_DEBUG;

	$r->header_out('Location', $url );
	$r->status( MOVED );
	$r->content_type( "text/html" );
	$r->send_http_header;
	$r->print( "\n<p>Cookie sent: ".  $value .".</P>" ) if $_DEBUG;
	$m->abort();
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

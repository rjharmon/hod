<%shared>
my $DEBUG = 0;
</%shared>
<%method .doc_synopsis>
(for developers) - Provides the Shopping Cart Manager an interface for fetching shopping-cart options.
</%method>
<%method .doc>
<h2>Usage</h2>
<pre><% <<EOD
\% my \$url = \$m->comp('/store/options.m', 
\%     option => 'checkout_url');

\% my(\$a,\$b) = \$m->comp('/store/options.m', 
\%     option => [ 'a', 'b' ] );
EOD
 |h %></pre>

<p>The first example fetches one setting.  The second example fetches a list 
of settings.  Note that a list context is required to fetch multiple settings.</p>

<h2>Setting Custom Options</h2>

<p>The Shopping Cart Manager provides default settings for most options, but you 
may wish to customize any or all of them.  To override settings, create a file 
<code>custom_options.m</code> in 
your web server's <code>/store/</code> directory (create the directory if it doesn't exist). Then, 
use the following format to set custom options:</p>

<pre><% <<EOD
<\%init>
return {
    continue_url => '/gallery.html',
	checkout_url => '/checkout.html',
	foo => sub {
		# context-sensitive setting here
		if( ... ) {
			return 'a';
		} else {
			return 'b';
		}
	},
};
</\%init>
EOD
 |h %></pre>

<p>In the example, the first two options (<code>continue_url</code>
and <code>checkout_url</code>) set static URLs for continuing the
shopping process and for jumping to the checkout page.  </p>

<p>The third option defines a subroutine that can return a different
setting for 'foo', depending on various factors. You might want to
send the customer to a different checkout page, depending on how much
information they've already provided, or you might have some other
wish we didn't foresee; this mechanism provides you that ability.  The
subroutine is a standard perl subroutine that currently is passed no
arguments.</p>

<p>This module will evaluate any such subroutines prior to returning 
the current setting, so that callers need not be concerned with that 
extra step.  If circumstances change in a way that would affect a 
option you've already retrieved, you will have to re-fetch that 
option to get its updated value.  Unless performance is at issue, 
therefore, we recommend 
fetching such settings each time they would be used.</p>

</%method>

<%args>
$option => undef
</%args>
<%init>
my $opts = {};
$opts = $m->fetch_comp('/store/custom_options.m');
if( $opts )  {
	$opts = $m->comp( $opts );
} else {
	$opts = {};
}
$opts = {
	continue_url => '/',
	checkout_url => '/store/checkout.html',
	product_detail_url => '/product_detail.html',
	max_width_large => 300,
	max_width_small => 180,
	max_height_large => 150,
	max_height_small =>  90,
	shop_custom_fields_global => [],
	
	payment_cards => [qw(Visa Mastercard Discover)],  #not Amex

	%$opts,
	style => sub { die "deprecated use of options.m->{style}" },
};

return $opts unless $option;

my $list = 0;
my @list;
if( ref( $option ) eq 'ARRAY' ) {
	$list = 1;
	die( "list context required if fetching multiple options" ) unless wantarray;
} else {
	$option = [ $option ];
}
foreach my $o ( @$option ) {
	my $opt = $opts->{$o};
	if( ref( $opt ) eq 'CODE' ) {
		$opt = $opt->(); # ??? send some args to it?
	}
	unless( $list ) {
		warn "returning ". Data::Dumper::Dumper( $opt ) if $DEBUG;
		return $opt;
	}
	push @list, $opt;
}
warn "returning ". Data::Dumper::Dumper( \@list ) if $DEBUG;
return @list;
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

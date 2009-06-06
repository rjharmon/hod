<%args>
$role => 'site_admin'
$area => 'a protected'
$silent => 0
</%args>
% $area = $ARGS{area} = "the $area" unless $area eq 'a protected';
<%def .session_reason_text>
You do not have permission to access this resource.  If this is
incorrect, you may provide your email address and contact the server
administrators to request permission.
</%def>
<%def .session_already_logged_in_text>
<%args>
$area => 'a protected'
</%args>
We have authenticated you as '<% $session->{email} %>'.  However, you have
not yet been given permission to access this resource.  Be assured that
the system administrators have been notified.  If your email address is
recognized, you'll be given access right away.  <br><br>

If you wish, you may <& /email_display.m, email => $r->server->server_admin,
	label => 'contact the server administrators',
	subject => "Getting access to $area area",
	body => "\nHelp! I can't get into $area area!\n\n".
		"I've authenticated as $session->{email}, and I'm writing ".
		"you from that email account.\n\n"
&><br><br>
</%def>
% $m->comp('/session.m');
% $role = [ $role ] unless ref( $role ) eq 'ARRAY';
% unless( grep { $session->{$_} } @$role ) {
% 	unless( $silent ) {
	<h2>Permission Denied</h2>

% 		$m->comp('/session/validate.m', %ARGS );
	<& /session/register.html, %ARGS &>
%	}
% return 0;
% }
% return 1;

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

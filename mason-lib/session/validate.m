<%args>
$optional => 0
</%args>
<%init>
$m->comp('/session.m', no_cookie_required => 1 );
return $session->{email} if $optional || $session->{email};
if( $r->method eq 'POST' && ! $optional ) {
	die( "Cannot complete required validation during POST. ".
		"Recommend you also gateway the pre-POST page. ".
		"This message may indicate a user searching for security vulnerabilities."
	);
}
</%init>
<& register.html, %ARGS &>
% return undef;

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

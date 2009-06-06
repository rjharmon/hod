<& /session/register.html, email => $ARGS{e}, vcode => $ARGS{v}, impersonate => $ARGS{impersonate} &>
<%def .no_signin>
The existence of this subcomp prevents the login form 
from being displayed by /session/validate.m
</%def>

<%method .skip_login_requirement>
The existence of this method allows /password.mason to skip the login requirement
when this page is being served.
</%method>

<%method .session_no_cookie_required>
The existence of this method prevents /session.m from implicitly sending a cookie.
Instead, /session/register.m will do it explicitly.
</%method>

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

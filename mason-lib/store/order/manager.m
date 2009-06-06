<%method .title>
Store Manager Login
</%method>
<%method .doc_synopsis>
Limits access, especially to order information in the Store Manager.
</%method>
<%init>
unless( $m->fetch_comp( '/store/manager_login.m' ) ) {
$m->out( <<EOD
<h2><font color=red>Development Error</font></h2>

<p>The store's reporting functions must be secured by password.  </p>

<p>To correct this problem, create a '/store/manager_login.m' component that
calls <a href="/doc.html?module=/password.mason">/password.mason</a>. </p>
EOD
);
 	return 0;
} else {
	return $m->comp('/store/manager_login.m', %ARGS);
}
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

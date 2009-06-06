<%args>
$name => $session->{special_offer}
</%args>
% use Date::Manip;
%
% my $o = $m->comp('/db_fetch.m', 
%	query => "SELECT * from offer where name=?",
%	args => $name,
% ); $o = $o->[0];
%
% return undef unless $o;
% return 0 if Date_Cmp( ParseDate( 'today' ), ParseDate( $o->{start_date} ) ) < 0;
% return 0 if Date_Cmp( ParseDate( 'today' ), ParseDate( $o->{end_date}   ) ) > 0;
% return $o;
% if( my $custom = $m->fetch_comp('/store/catalog/offers/custom_offer.m') ) {
%	$m->comp( $custom );
% } else {
%	die("Special offers currently require /store/catalog/offers/custom_offer.m to set per-item discounts.")
%		if $session->{special_offer};
% }
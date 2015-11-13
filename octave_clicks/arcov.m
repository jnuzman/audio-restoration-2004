## ARCOV  calculate autoregressive parameters using covariance method

## ref DAR (4.51)
## ref Papoulis (14-66)

## optmz: reuse sumsq(x_1), avoid creating G at all

function [a, pe_ms_est] = arcov(x_1, G)

assert(isvector(x_1) && (columns(x_1) == 1));
assert((rows(G) == length(x_1))); #(columns(G) == p));

## approximates autocorr at lag = index (if scaled by length)
r = G' * x_1;

## todo: what about invertability, what about stability
a = inv(G'*G) * r;

## experimental!!!
## ##  a = poly2ar(polystab(ar2poly(a')))';
## rts = roots(ar2poly(a'));
## v = find(abs(rts)>1);
## if (rows(v) > 0)
##   rts(v) = 1 ./ conj(rts(v));
##   a = poly2ar(real(poly(rts)))';
## end

x_1_ms = sumsq(x_1) / length(x_1);

## notice x_1 only
pe_ms_est = x_1_ms - ( (a'*r) / length(x_1) );

assert((rows(a) == columns(G)) && (columns(a) == 1));
##dbg assert(isscalar(pe_ms_est) && (pe_ms_est >= 0) && (pe_ms_est <= x_1_ms));




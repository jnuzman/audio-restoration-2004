## WIENERSR returns the spectral gain using the wiener suppression rule

## ref Cappe/Laroche94 (3) (5)

function [G_curr] = wienersr(X_curr, L_d, alpha, gainfloor)

## alpha 1, or > 1 to overestimate noise
## perhaps 3 - 6 (hoeldrich alpha0, dar)
## gainfloor 0.1 - 0.01 for high noise signals, less for low noise (hoeldrich)

bins = rows(X_curr);

assert(columns(X_curr) == 1);
assert(rows(L_d) == bins);
assert(columns(L_d) == 1);
assert(isscalar(alpha));
assert((alpha > 0));
assert(isscalar(gainfloor));
assert((gainfloor >= 0) && (gainfloor <= 1));


Q = abs(X_curr).^2 ./ (alpha .* L_d);

Q(Q < 1) = 1;

G_curr = 1 - 1./Q;

G_curr(G_curr < gainfloor) = gainfloor;

assert((rows(G_curr)==bins) && (columns(G_curr)==1));

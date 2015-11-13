## EMSR returns the spectral gain using the EMSR suppression rule

## ref Cappe Musical Noise (1),(2),(3)

function [G_curr] = emsr(X_curr, v, GX_prev, alpha, R_min, q) 

## alpha typically 0.98
## R_min should be around avg(R_prio) in noise-only area
## for alpha=0.98 this is about -15 dB (0.0316)
## can be higher if more resid noise is desired (cappe musical)
## EM 84 suggests above alpha for q = 0
## otherwise, suggests q = 0.2 and alpha = 0.99

bins = rows(X_curr);

assert(columns(X_curr) == 1);
assert(rows(v) == bins);
assert(columns(v) == 1);
assert(all(v>0));
assert(rows(GX_prev)==bins);
assert(columns(GX_prev) == 1);
assert(isscalar(alpha));
assert((alpha >= 0) && (alpha <= 1));
assert(isscalar(R_min))
assert((R_min >= 0) && (R_min <= 1));
assert(isscalar(q));
assert((q>=0) && (q<1));


R_post = (abs(X_curr).^2 ./ v) - 1;
##R_post(R_post > 160) = 160;

P_R_post = (R_post > 0) .* R_post; # zero anything < 0

R_prio = (1 - alpha).*P_R_post + alpha.*(abs(GX_prev).^2)./v;

R_prio(R_prio < R_min) = R_min;

## include uncertainty of signal presence
## checkme: before/after noise floor?
R_prio = R_prio ./ (1-q);

### NOTE ###
## Octave seems to choke if the argument of besseli > 81.  Therefore, we
## make sure that R_post <= 160 (see theta/halftheta). The actual gain
## shouldn't really change much for R_post > 100 (20dB) anyway,
## see Cappe Music Noise 94.
## todo: decide if R_post's influence on R_prior should be capped

R_post(R_post > 160) = 160;

theta = (1 + R_post) .* (R_prio ./ (1 + R_prio));
halftheta = theta./2;


M = exp(- halftheta) .* \
    ( (1+theta).*besseli(0,halftheta) + theta.*besseli(1,halftheta));

G_curr = sqrt(pi)/2 .* \
    sqrt( (1./(1+R_post)) .* (R_prio ./ (1 + R_prio)) ) .* M;


if (q > 0)
  ## ref EM84 (30)
  mu = (1-q)/q;
  Lambda = mu .* exp(theta) ./ (1 + R_prio);
  G_curr = Lambda ./ (1 + Lambda) .* G_curr;
end


assert((rows(G_curr)==bins) && (columns(G_curr)==1));


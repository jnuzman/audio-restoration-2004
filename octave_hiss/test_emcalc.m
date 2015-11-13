function [G_curr] = test_emcalc(R_prio, R_post, q, R_min)

if (length(R_post) == 1)
  R_post = ones(length(R_prio),1) .* R_post;
end

assert(length(R_prio)==length(R_post));

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

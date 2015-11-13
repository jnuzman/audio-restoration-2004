## AR_FILT_BACK produce residual after BACKWARDS filtering with given AR parms

## ref DAR 5.3.1.2

function [resid] = ar_filt_back(x, a, G)

p = length(a);
n = length(x);
w = n - 2*p;

assert(isvector(x) && (columns(x) == 1));
assert(isvector(a) && (columns(a) == 1));
assert(w > 0);
assert(rows(G)==(n-p));
assert(columns(G)==rows(a));

## assume G was produced with same x, so we can skip first p samps
## of x
## assume further that we only want w samples

a_b = flipud(a);

## what we want are predictors from x(p+1) to x(n-p)
## it is evident from DAR (4.47) that mulitplying the
## ith row of G by a_b yields the predictor for x(i-1)

pred = zeros(w,1);

pred(1:w-1) = G(p+2:n-p,:)*a_b;

## we have to do the last one, cuz it doesn't appear in G
pred(w) = fliplr(x(n-p+1:n)')*a_b;

resid = x(p+1:p+w) - pred;

assert((rows(resid)==w)&&(columns(resid)==1));

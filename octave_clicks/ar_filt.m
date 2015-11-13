## AR_FILT produce residual after filtering with given AR parms

function [resid] = ar_filt(x, a, G)

p = rows(a);
n = length(x);
w = n - 2*p;

assert(isvector(x) && (columns(x) == 1));
## p=0 case? assert(isvector(a) && (columns(a) == 1));
assert((columns(a) == 1));
assert(w > 0);
assert(rows(G)==(n-p));
assert(columns(G)==rows(a));

## assume G was produced with same x, so we can skip first p samps
## of x
## assume further that we only want w samples

resid = x(p+1:p+w) - G(1:w,:)*a;

assert((rows(resid)==w)&&(columns(resid)==1));

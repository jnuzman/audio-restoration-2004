## MAKEARMAT produce the autoregression matrix

## ref DAR (4.46)

function [G] = makearmat(x, p)

assert(isvector(x) && (columns(x) == 1));
assert(isscalar(p) && (round(p) == p) && (p >= 0));
assert(length(x) > p);

n = length(x);

G = zeros(n - p, p);

for k = 1:p
  G(:,k) = x((p+1-k):(n-k));
end

assert((rows(G) == (n-p)) && (columns(G) == p));


## SINLS  fit some sinusoidal bases with least squares

## ref DAR 5.2.3.2
## ref DAR (4.6)

function [c] = sinls(x, G)

assert(isvector(x) && (columns(x) == 1));
assert((rows(G)==length(x))); #&&(columns(G)==q));

## todo: what about invertability
c = inv(G'*G) * G' * x;

assert((rows(c) == columns(G)) && (columns(c) == 1));


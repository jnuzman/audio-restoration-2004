## SIN_MODEL determine parameters for sinusoidal basis model

function [c freqs G] = sin_model(x, q, w, offset)

assert(isscalar(w) && (round(w)==w));
assert(w >= 1);
assert(round(log2(w))==log2(w)); #not strictly necessary
assert(isscalar(offset) && (round(offset)==offset));
assert(offset >= 0);
assert((offset+w)<=length(x));


freqs = pickfreqs(x(offset+1:offset+w), q); #use pow2 window for eff.

## by convention, have zero-phase be at x(offset+1)
G = makesinmat(freqs, length(x), offset);

c = sinls(x, G);


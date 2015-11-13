## SIN_SYNTH given sinusoids and resid, synthesize combined process

function [x] = sin_synth(c, freqs, resid, offset)

assert(isvector(c) && (columns(c)==1));
assert(isvector(resid) && (columns(resid)==1));

## offset specifies the offset of zero-phase (CAN be <= 0 or >= len(resid))
G = makesinmat(freqs, length(resid), offset);

x = G*c + resid;

assert((rows(x)==rows(resid)) && (columns(x)==1));
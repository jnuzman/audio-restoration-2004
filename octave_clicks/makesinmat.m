## MAKESINMAT produce matrix of sinusoidal basis vectors

## ref DAR 5.2.3.2

function [G] = makesinmat(freqs, len, t_off)

assert(isvector(freqs)||isempty(freqs));
assert(isscalar(len) && (round(len)==len));
assert(len >= 0);
assert(isscalar(t_off));

## include DC unconditionally
bases = 2*length(freqs)+1;

G = zeros(len, bases);

## t_off specifies offset of zero-phase index
##t = (0:len-1)';
t = (0-t_off:len-1-t_off)';
omega = 2*pi*freqs;

for k=1:length(freqs)
  G(:,2*k-1) = cos(t.*omega(k));
  G(:,2*k)   = sin(t.*omega(k));
end

## include DC unconditionally
G(:,bases) = ones(len, 1);

assert((rows(G)==len)&&(columns(G)==bases));


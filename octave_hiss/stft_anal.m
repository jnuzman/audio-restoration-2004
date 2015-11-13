## STFT_ANAL perform the overlap-add short time discrete fourier transform

function [stft] = stft_anal(x, w, overlap_fact, prewin)

assert(isvector(x) && (columns(x)==1));
assert(isscalar(w) && (pow2(floor(log2(w)))==w));
assert(isscalar(overlap_fact) && (floor(w/overlap_fact)==w/overlap_fact));
assert((0<overlap_fact)&&(w<=length(x)));

incr = w / overlap_fact;

count = floor((length(x) - w) / incr) + 1;

stft = zeros(w, count);

for k=1:count
  base = (k-1)*incr;
  stft(:,k) = fft(prewin .* x(base+1:base+w));
end

assert((rows(stft)==w) && (columns(stft)==count));

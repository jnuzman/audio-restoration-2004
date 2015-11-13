## STFT_SYNTH produces time domain sequence using overlap-add

function [x] = stft_synth(stft, postwin, overlap_fact);

w = rows(stft);
count = columns(stft);

assert((rows(postwin)==w) && (columns(postwin)==1));
assert(isscalar(overlap_fact) && (floor(w/overlap_fact)==w/overlap_fact));
assert((0<overlap_fact));

incr = w / overlap_fact;

x = zeros((count-1)*incr+w,1);

for k=1:count
  base = (k-1)*incr;
  x(base+1:base+w) += postwin .* real(ifft(stft(:,k)));
end

assert((rows(x)==(count-1)*incr+w) && (columns(x)==1));

## PICKFREQS  pick some sinusoidal bases with fft

## ref DAR 5.2.3.2

function [freqs] = pickfreqs(x, q)

assert(isvector(x) && (columns(x) == 1));
assert(isscalar(q));
assert((2*floor(q/2)+1 == q) || (q == 0)); #q odd or 0
assert(q < (length(x)/2));

num_maxs = floor(q/2);

if (num_maxs > 0)

  ## todo: prewindowing of fft, something better
  ## checkme: robustness, granularity
  fft_out = fft(x); 

  FP = abs(fft_out(1:floor(length(fft_out)/2))); # take only first half

  [s, i] = sort(FP(2:length(FP)));  #drop DC, also shift indexes appropriately
  freqs = i((length(i)-num_maxs+1):length(i));
  freqs = freqs ./ length(fft_out);

  ##optmz: this step is unnecessary
  freqs = flipud(freqs);

else

  freqs = zeros(0,1);  # zero width

end

assert((rows(freqs)==floor(q/2)) && (columns(freqs) == 1))
assert(all(freqs>0) && all(freqs<0.5));

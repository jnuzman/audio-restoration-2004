## EST_POWER estimate the power spectrum of the stationary process with
## stft

function [s_n] = est_power(x, w, overlap_fact)

incr = w / overlap_fact;

count = floor((length(x) - w) / incr) + 1;

prewin = hanning(w);

s_n = zeros(w,1);

for k=1:count

  base = (k-1)*incr;

  stft = stft_anal(x(base+1:base+w), w, overlap_fact, prewin);

  ## time average each bin
  s_n += abs(stft).^2;

end

s_n = s_n ./ count;

assert(isreal(s_n) && (rows(s_n)==w) && (columns(s_n)==1));
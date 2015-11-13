## DO_STSA get the short-time spectral amplitude for each window

function [STSA] = do_stsa(x, w, overlap_fact)

incr = w / overlap_fact;

count = floor((length(x) - w) / incr) + 1;

prewin = hanning(w);

nyq = floor(w/2)+1;

## for memory reasons we only save what we need
STSA = zeros(nyq,count);

for k=1:count

  base = (k-1)*incr;

  X_in = stft_anal(x(base+1:base+w), w, overlap_fact, prewin);

  STSA(:,k) = abs(X_in(1:nyq));

end

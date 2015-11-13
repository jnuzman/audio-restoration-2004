## DO_IDEALZEROPHASE

function [x_out] = do_idealzerophase(x_dirty, w, overlap_fact, x_clean)

assert(length(x_dirty)==length(x_clean));

incr = w / overlap_fact;

count = floor((length(x_dirty) - w) / incr) + 1;

prewin = hanning(w);

postwin = makepostwin(prewin, overlap_fact);

x_out = zeros(rows(x_dirty),1);

for k=1:count

  base = (k-1)*incr;

  X_dirty = stft_anal(x_dirty(base+1:base+w), w, overlap_fact, prewin);

  X_clean = stft_anal(x_clean(base+1:base+w), w, overlap_fact, prewin);

  assert(! any(abs(X_dirty)==0));

  X_out = abs(X_clean)./abs(X_dirty) .* X_dirty;

  x_out(base+1:base+w) += stft_synth(X_out, postwin, overlap_fact);

end



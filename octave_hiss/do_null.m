## DO_NULL a null STSA filter

function [x_out] = do_null(x_in, w, overlap_fact)

incr = w / overlap_fact;

count = floor((length(x_in) - w) / incr) + 1;

prewin = hanning(w);

postwin = makepostwin(prewin, overlap_fact);

x_out = zeros(rows(x_dirty),1);

for k=1:count

  base = (k-1)*incr;

  X_in = stft_anal(x_in(base+1:base+w), w, overlap_fact, prewin);

  x_out(base+1:base+w) += stft_synth(X_in, postwin, overlap_fact);

end



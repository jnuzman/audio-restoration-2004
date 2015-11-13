## DO_WIENER apply wiener suppression to signal

function [x_out] = do_wiener(x_in, w, overlap_fact, L_d, alpha, gainfloor)

incr = w / overlap_fact;

count = floor((length(x_in) - w) / incr) + 1;

prewin = hanning(w);

postwin = makepostwin(prewin, overlap_fact);

x_out = zeros(rows(x_in),1);

for k=1:count

  base = (k-1)*incr;

  X_in = stft_anal(x_in(base+1:base+w), w, overlap_fact, prewin);

  X_out = wienersr(X_in, L_d, alpha, gainfloor) .* X_in;

  x_out(base+1:base+w) += stft_synth(X_out, postwin, overlap_fact);

end




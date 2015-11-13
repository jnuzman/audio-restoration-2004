## DO_EM apply Ephraim-Mallah suppression to signal

function [x_out] = do_em(x_in, w, overlap_fact, v, alpha, R_min, q)

incr = w / overlap_fact;

count = floor((length(x_in) - w) / incr) + 1;

prewin = hanning(w);

postwin = makepostwin(prewin, overlap_fact);

x_out = zeros(rows(x_in),1);

##GX_prev = sqrt(0.0316 .* v); # checkme: is this proper?
##GX_prev = sqrt(sx);
## answer from EM84: GX_prev^2/v == 1
GX_prev = sqrt(v);

for k=1:count

  base = (k-1)*incr;

  X_in = stft_anal(x_in(base+1:base+w), w, overlap_fact, prewin);

  X_out = emsr(X_in, v, GX_prev, alpha, R_min, q) .* X_in;

  GX_prev = X_out;

  x_out(base+1:base+w) += stft_synth(X_out, postwin, overlap_fact);

end





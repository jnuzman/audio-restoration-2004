## DO_ARSIN_MODEL determine AR + sinusoid parameters for each window

function [AR, C, Freqs, pe_ms_est, sinresid_ms, x_ms] = \
    do_arsin_model(x, p, q, w, lead_in, lead_out);

count = floor((length(x)-lead_out-lead_in)/w);  # number of windows

assert(isvector(x) && (columns(x) == 1));
assert(isscalar(p) && (round(p)==p));
assert(p >= 0);
assert(isscalar(q));
assert((2*floor(q/2)+1 == q) || (q == 0)); #q odd or 0
assert(q >= 0);
assert(isscalar(w) && (round(w)==w));
assert(w >= 1);
assert((p <= lead_in) && (p <= lead_out));
assert(count > 0); # equiv assert((lead_in+lead_out+w)<=length(x));
assert(isscalar(lead_in) && (round(lead_in)==lead_in));
assert(lead_in >= 0);
assert(isscalar(lead_out) && (round(lead_out)==lead_out));
assert(lead_out >= 0);

AR = zeros(p,count);
C = zeros(q,count);  # always includes DC
Freqs = zeros(floor(q/2),count);
pe_ms_est = zeros(1,count);
sinresid_ms = zeros(1,count);
x_ms = zeros(1,count);


low = lead_in + 1;
high = low + w - 1;

for k=1:count
  x_ms(k) = sumsq(x(low:high))/w;
  sinresid_ms(k) = x_ms(k); # default, if q == 0

  seq = x(low-p:high+p);

  if (q > 0)

    [C(:,k) Freqs(:,k) Gsin] = sin_model(seq, q, w, p);

    seq = sin_filt(seq, C(:,k), Gsin);

    sinresid_ms(k) = sumsq(seq(p+1:p+w))/w; #only over window

  end

  ## note that pe_ms_est is across window+2p's
  [AR(:,k), pe_ms_est(k), Gar] = ar_model(seq, p);


  low = low + w;
  high = high + w;
end


assert((rows(AR)==p) && (columns(AR)==count));
assert((rows(C)==q) && (columns(C)==count));
assert((rows(Freqs)==floor(q/2)) && (columns(Freqs)==count));
assert((rows(sinresid_ms)==1) && (columns(sinresid_ms)==count));
assert((rows(pe_ms_est)==1) && (columns(pe_ms_est)==count));
assert((rows(x_ms)==1) && (columns(x_ms)==count));

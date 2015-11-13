## DO_ARSIN_INTERP interpolate missing data for each window

function [x sse] = do_arsin_interp(x, p, q, w, lead_in, lead_out, \
				   idv, x_clean, interp_iters)

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

assert(length(idv)==length(x));
assert(length(x_clean)==length(x));

low = lead_in+1;
high = low + w - 1;

sse = zeros(interp_iters+1,1);

for k=1:count

##  [k low]

  [x_1 wsse] = arsin_interp(x(low:high+p), p, q, x(low-p:low-1),
			    x(high+1+p:high+p+p), idv(low:high+p),
			    x_clean(low:high), interp_iters);

##  x(low:high) = x_1;
  x(low:high) = x_1(1:w);

  sse = sse + wsse;

  low = low + w;
  high = high + w;
end

assert(isvector(x) && (columns(x) == 1));





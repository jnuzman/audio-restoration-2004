## DO_ARSIN_PROCESS detect and remove clicks for each window

function [x id] = do_arsin_process(x, p, q, w, lead_in, lead_out, \
				   threshold, fatness, interp_iters)

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

low = lead_in+1;
high = low + w - 1;

id = zeros(0, 1);

for k=1:count

##  [k low]

##  [x_1 wid] = arsin_process(x(low:high), p, q, x(low-p:low-1),
##			    x(high+1:high+p), threshold);
  [x_1 wid] = arsin_process(x(low:high+p), p, q, x(low-p:low-1), \
			    x(high+1+p:high+p+p), threshold, fatness, \
			    interp_iters);

  if (length(wid) > 0)
  wid = wid(wid <= w);

  wid = wid + (low-1);
  id = [id; wid];

##  x(low:high) = x_1;
  x(low:high) = x_1(1:w);
  end

  low = low + w;
  high = high + w;
end

assert(isvector(x) && (columns(x) == 1));
assert((columns(id) <= 1));
assert(rows(id) <= count*w);




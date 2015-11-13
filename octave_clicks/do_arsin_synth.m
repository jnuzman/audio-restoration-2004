## DO_ARSIN_SYNTH synthesize AR+sinusoid given resid + parms for each
## win

function [x] = do_arsin_synth(AR, C, Freqs, PE, x_init)

p = rows(AR);
q = rows(C);
w = rows(PE);
count = columns(AR);

assert(columns(C)==count);
assert(columns(Freqs)==count);
assert(columns(PE)==count);

assert(rows(Freqs)==floor(q/2));
assert((rows(x_init)==p) && (columns(x_init)==1));

x = zeros(w*count,1);

x_0 = x_init;
index = 0;

for k=1:count

  if ((q > 0) && (p > 0))
    Gsin_0 = makesinmat(Freqs(:,k), length(x_0), p);
    x_0 = sin_filt(x_0, C(:,k), Gsin_0);
  end

  x_1 = ar_synth(AR(:,k), PE(:,k), x_0);

  if (q > 0)
    x_1 = sin_synth(C(:,k), Freqs(:,k), x_1, 0);
  end

  x(index+1:index+w) = x_1;

  index = index + w;
  if (p>0)
  x_0 = x_1(w-p+1:w);
  end

end


assert((rows(x)==(w*count)) && (columns(x)==1));
## DO_ARSIN_SYNTH_BACK synth AR+sin given back resid + parms for each
## win

function [x] = do_arsin_synth_back(AR, C, Freqs, PE_back, x_post)

p = rows(AR);
q = rows(C);
w = rows(PE_back);
count = columns(AR);

assert(columns(C)==count);
assert(columns(Freqs)==count);
assert(columns(PE_back)==count);

assert(rows(Freqs)==floor(q/2));
assert((rows(x_post)==p) && (columns(x_post)==1));

x = zeros(w*count,1);

x_0 = x_post;
index = 1+w*count-w;

for k=count:-1:1

  if (q > 0)
    Gsin_0 = makesinmat(Freqs(:,k), length(x_0), -w);
    x_0 = sin_filt(x_0, C(:,k), Gsin_0);
  end

  x_1 = ar_synth_back(AR(:,k), PE_back(:,k), x_0);

  if (q > 0)
    x_1 = sin_synth(C(:,k), Freqs(:,k), x_1, 0);
  end

  x(index:index+w-1) = x_1;

  index = index - w;
  x_0 = x_1(1:p);

end


assert((rows(x)==(w*count)) && (columns(x)==1));

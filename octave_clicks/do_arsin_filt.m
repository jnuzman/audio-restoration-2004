## DO_ARSIN_FILT produce residual after applying AR + sinusoid for each window

function [PE x_init PE_back x_post] = do_arsin_filt(x, AR, C, Freqs, \
					   w, lead_in, lead_out, \
					   dobackward, phase_trick)

## lets me to tricky things with sinusoid phase 
if (nargin < 9)
  phase_trick = 0;
end
if (phase_trick == 1)
  phase_shift = -w;
else
  phase_shift = 0;
end

count = floor((length(x)-lead_out-lead_in)/w);  # number of windows

p = rows(AR);
q = rows(C);

assert(isvector(x) && (columns(x) == 1));
assert(columns(AR)==count);
assert(columns(C)==count);
assert(columns(Freqs)==count);

assert(isscalar(w) && (round(w)==w));
assert(w >= 1);
assert((p <= lead_in) && (p <= lead_out));
assert(count > 0); # equiv assert((lead_in+lead_out+w)<=length(x));
assert(isscalar(lead_in) && (round(lead_in)==lead_in));
assert(lead_in >= 0);
assert(isscalar(lead_out) && (round(lead_out)==lead_out));
assert(lead_out >= 0);

assert((dobackward==0)||(dobackward==1));


PE = zeros(w,count);
x_init = zeros(p,1);
PE_back = zeros(dobackward*w, count);
x_post = zeros(dobackward*p,1);


low = lead_in + 1;
high = low + w - 1;

x_init = x(low-p:low-1,1);
if (dobackward == 1)
  x_post = x(lead_in+w*count+1:lead_in+w*count+p);
end

for k=1:count

  seq = x(low-p:high+p);

  if (q > 0)

    Gsin = makesinmat(Freqs(:,k), length(seq), p + phase_shift);

    seq = sin_filt(seq, C(:,k), Gsin);

  end

  Gar = makearmat(seq, p);

  PE(:,k) = ar_filt(seq, AR(:,k), Gar);

  if (dobackward == 1)
    PE_back(:,k) = ar_filt_back(seq, AR(:,k), Gar);
  end


  low = low + w;
  high = high + w;
end

assert((rows(PE)==w)&&(columns(PE)==count));
assert((rows(x_init)==p)&&(columns(x_init==1)));
assert((rows(PE_back)==(dobackward*w))&&(columns(PE_back)==count));
assert((rows(x_post)==(dobackward*p))&&(columns(x_post)==1));

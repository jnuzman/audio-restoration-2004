function [P_fp, P_fn, MA_fn] = testthresh(pe, id, threshold, fatness, noise)

assert(length(pe)==length(id));

assert(isvector(threshold));
assert(isvector(fatness));

P_fp = zeros(length(threshold),length(fatness)); ## prob. false pos
P_fn = zeros(length(threshold),length(fatness)); ## prob. false neg
MA_fn = zeros(length(threshold),length(fatness)); ## max ampl. of undet.
						  ## noise

fatidt = zeros(length(id),1);

tic();

dirty = sum(id);
clean = sum(~id);
assert((dirty+clean)==length(id));
assert((dirty>0) && (clean>0));

na = abs(noise);

for r=1:length(threshold)

  for c=1:length(fatness)

    [threshold(r) fatness(c)]

    idt = (pe > threshold(r));
    idt = [zeros(fatness(c),1); idt; zeros(fatness(c),1)];
    for k=1:length(pe)
      fatidt(k) = any(idt(k:k+2*fatness(c)));
    end

    ifn = (id & ~fatidt);
    fn = sum(ifn);
    fp = sum(~id & fatidt);
    ma_fn = max(na(ifn));

    P_fn(r,c) = fn/dirty;
    P_fp(r,c) = fp/clean;
    MA_fn(r,c) = ma_fn;

  end

end
t = toc()





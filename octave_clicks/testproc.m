function [SSE] = testproc(x, p, q, w, lead_in, lead_out, threshold, \
			    fatness, interp_iters, x_clean_cropped)

assert(length(x)>length(x_clean_cropped));

assert(isvector(threshold));
assert(isvector(fatness));

SSE = zeros(length(threshold),length(fatness)); ## sumsq error

tot=0;

for r=1:length(threshold)

  for c=1:length(fatness)

    [threshold(r) fatness(c)]

    tic();
    [x_proc id] = do_arsin_process(x, p, q, w, lead_in, lead_out, \
				   threshold(r), fatness(c), interp_iters);
    t=toc()
    tot+=t;

    SSE(r,c) = sumsq(x_clean_cropped - \
		     x_proc(lead_in+1:lead_in+length(x_clean_cropped)))

  end

end
tot





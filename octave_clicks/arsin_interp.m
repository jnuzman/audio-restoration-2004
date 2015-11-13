## ARSIN_INTERP interpolate missing data

function [x_1 sse] = arsin_interp(x_1, p, q, x_0, x_tail, idv, \
				   x_clean, interp_iters)

w = length(x_1);
p2w = 2^(floor(log2(w)));

seq = [x_0; x_1; x_tail];

sse = zeros(interp_iters+1,1); 

## if (q > 0)

  [c freqs Gsin] = sin_model(seq, q, p2w, p);

##  seq = sin_filt(seq, c, Gsin);

  sins = Gsin*c;

  seq = seq - sins;

## end

## todo robustify
## note that pe_ms_est is across window+2p's
[a, pe_ms_est, Gar] = ar_model(seq, p);

id = find(idv);

if (length(id) > 0)

  idc = id(id <= length(x_clean));
  sse(1) = sumsq(x_1(idc) - x_clean(idc));

#  interp_iters = 4;

  for k=1:interp_iters

    x_id_prev = x_1(id);

    ## checkme: should we include the tail p?
    ##          pos is that estimates at end of window would match up
    ##          neg is that clicks in tail could influence estimates
    seq_id = ar_interp(seq(p+1:p+w), a, id, seq(1:p)); 

    ## todo:  loop here with ar_model?

    x_1(id) = seq_id + sins(id+p);

    ## or loop here with arsin_model?

    x_id_ms = sumsq(x_id_prev - x_1(id)) / length(id);
    
    sse(k+1) = sumsq(x_1(idc) - x_clean(idc));

##    [k x_id_ms pe_ms_est]

    seq = [x_0; x_1; x_tail];

    [c freqs Gsin] = sin_model(seq, q, p2w, p);

    ##  seq = sin_filt(seq, c, Gsin);

    sins = Gsin*c;

    seq = seq - sins;

    ## todo robustify (even at this stage???)
    ## note that pe_ms_est is across window+2p's
    [a, pe_ms_est, Gar] = ar_model(seq, p);

  end

end





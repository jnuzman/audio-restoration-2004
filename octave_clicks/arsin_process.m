## ARSIN_PROCESS detect and remove clicks

function [x_1 id] = arsin_process(x_1, p, q, x_0, x_tail, threshold, \
				  fatness, interp_iters)

w = length(x_1);
p2w = 2^(floor(log2(w)));

seq = [x_0; x_1; x_tail];

## if (q > 0)

  [c freqs Gsin] = sin_model(seq, q, p2w, p);

##  seq = sin_filt(seq, c, Gsin);

  sins = Gsin*c;

  seq = seq - sins;

## end

## todo robustify
## note that pe_ms_est is across window+2p's
[a, pe_ms_est, Gar] = ar_model(seq, p);

pe = ar_filt(seq, a, Gar);

##  if (dobackward == 1)
##    PE_back(:,k) = ar_filt_back(seq, AR(:,k), Gar);
##  end

## done -> todo robustify
## pe_rms = sqrt(sumsq(pe)/length(pe));
## robust:
pe_rms = median(abs(pe))./0.6745;

id = identify_clicks(pe, pe_rms, threshold, fatness);

if (length(id) > 0)

##  interp_iters = 4;

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





function [p_resid ps t_model t_filt] = testwin(p, q, w, iwoke)

assert(isscalar(p));
assert(isscalar(q));
assert(isvector(w));

lead_in = lead_out = 1024;

## make sure tested sequence is the same for all sizes
count = floor((length(iwoke)-lead_in-lead_out) / max(w));
last = lead_in+(count*max(w));
lead_out = length(iwoke)-last;

p_resid = zeros(length(w),1);
t_model = zeros(length(w),1);
t_filt = zeros(length(w),1);


for k=1:length(w)

    [w(k)]

    tic();
    [AR C Freqs pe_ms_est sinresid_ms x_ms] = \
	do_arsin_model(iwoke, p, q, w(k), lead_in, lead_out);
    tm = toc()
    t_model(k) = tm;
    
    tic();
    [PE x_init PE_back x_post] = \
	do_arsin_filt(iwoke, AR, C, Freqs, w(k), lead_in, lead_out, 0);
    tf = toc()
    t_filt(k) = tf;

    p_resid(k) = mean(mean(PE.^2));

  end

end

ps = mean(x_ms); # should never change



#  for layer=1:min(length(p),length(q))

#    for k=1:(layer-1)

#      PSRR(layer,k) = p(layer) + q(k);

#      PSRR(k,layer) = p(k) + q(layer);

#    end

#    PSRR(layer,layer) = p(layer) + q(layer);

#  end

#  for layer=(length(q)+1):length(p)
#    for k=1:length(q)
#      PSRR(layer,k) = p(layer) + q(k);
#    end
#  end

#  for layer=(length(p)+1):length(q)
#    for k=1:length(p)
#      PSRR(k,layer) = p(k) + q(layer);
#    end
#  end



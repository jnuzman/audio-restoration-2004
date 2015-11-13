function [P_resid ps T_model T_filt] = testar(p, q, w, iwoke)

assert(isvector(p));
assert(isvector(q));
assert(isscalar(w));

lead_in = lead_out = 1024;

P_resid = zeros(length(p),length(q));
T_model = zeros(length(p),length(q));
T_filt = zeros(length(p),length(q));


for r=1:length(p)

  for c=1:length(q)

    [p(r) q(c)]

    tic();
    [AR C Freqs pe_ms_est sinresid_ms x_ms] = \
	do_arsin_model(iwoke, p(r), q(c), w, lead_in, lead_out);
    tm = toc()
    T_model(r,c) = tm;
    
    tic();
    [PE x_init PE_back x_post] = \
	do_arsin_filt(iwoke, AR, C, Freqs, w, lead_in, lead_out, 0);
    tf = toc()
    T_filt(r,c) = tf;

    P_resid(r,c) = mean(mean(PE.^2));

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



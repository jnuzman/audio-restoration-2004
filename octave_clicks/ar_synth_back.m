## AR_SYNTH_BACK given AR coeffs and backwards resids, synthesize
## process

function [x] = ar_synth_back(a, resid, x_post)

x_rev = ar_synth(a, flipud(resid), flipud(x_post));

x = flipud(x_rev); 
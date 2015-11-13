## AR_MODEL determine parameters for AR model

function [a, pe_ms_est, G] = ar_model(x, p)

G = makearmat(x, p);

[a pe_ms_est] = arcov(x(p+1:length(x)), G);

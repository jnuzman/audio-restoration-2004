## SIN_FILT produce residual after filtering with given sinusoid parms

function [resid] = sin_filt(x, c, G)

resid = x - G*c;


function [pre post] = comparefilt(PRE, POST, m);

PRE = PRE(:,1+m:columns(PRE)-m);

pre = reshape(PRE, rows(PRE)*columns(PRE), 1);
post = reshape(POST, length(pre), 1);

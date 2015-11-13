## IDENTIFY_CLICKS identify clicks given prediction error seq

function [id] = identify_clicks(pe, pe_rms, threshold, fatness)

assert(isvector(pe) && (columns(pe)==1));
assert(isscalar(pe_rms));
assert(pe_rms > 0);
assert(isscalar(threshold));
assert(threshold > 0);

##id = find(abs(pe) > (pe_rms * threshold));

##idv = zeros(rows(pe),1);
##idv(id) = ones(rows(id),1);
idv = (abs(pe) > (pe_rms * threshold));

width = fatness;
idv = [zeros(width,1); idv; zeros(width,1)];
for k=1:length(pe)
  fatidv(k) = any(idv(k:k+2*width));
end

##for k=width+1:length(pe)-width
##  fatidv(k) = any(idv(k-width:k+width));
##end
##for k = 1:width
##  fatidv(k) = any(idv(1:k+width));
##  fatidv(length(pe)+1-k) = any(idv(length(pe)+1-k-width:length(pe)));
##end

id = find(fatidv);

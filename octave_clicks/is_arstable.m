## IS_ARSTABLE are the roots for each column of AR coeffs within unit
## circle

function [result index] = is_arstable(AR);

result = 1;
index = zeros(1, 0);

for k = 1:columns(AR)
  if (! (all(abs(roots(ar2poly(AR(:,k)'))) < 1)) ) 
    result = 0;
    index = [index(1,:) k];
  end
end

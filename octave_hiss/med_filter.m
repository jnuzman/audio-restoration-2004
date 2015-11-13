## MED_FILTER apply a median filter along each row

function [A_out] = med_filter(A_in, m);

A_out = zeros(rows(A_in), columns(A_in)-2*m);

for k=1:columns(A_out)

  A_out(:,k) = median(A_in(:,k:k+2*m).').';

end

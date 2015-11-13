## AVG_FILTER apply a mean filter along each row

function [A_out] = avg_filter(A_in, m);

A_out = zeros(rows(A_in), columns(A_in)-2*m);

for k=1:columns(A_out)

  A_out(:,k) = mean(A_in(:,k:k+2*m).').';

end

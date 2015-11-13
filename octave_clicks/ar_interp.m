## AR_INTERP estimate missing data using LS AR model

## ref DAR (5.15)

function [x_id] = ar_interp(x_1, a, id, x_0)

assert(isvector(x_1) && (columns(x_1)==1));
assert(isvector(a) && (columns(a)==1));
assert((columns(id)<=1));
assert(isvector(x_0) && (columns(x_0)==1));
assert(rows(x_0)==rows(a));
assert(rows(id) < rows(x_1));

x_id = zeros(rows(id),1);

if (length(id) > 0)

  x = [x_0; x_1];
  
  n = length(x);
  p = length(a);

  ## use toeplitz?
  A = zeros(n-p,n);

  arow = [-fliplr(a') 1];
 
  ## ref DAR (4.53)
  for k = 1:n-p
    A(k,k:k+p) = arow;
  end

  ## this is not so efficient
  idv = zeros(length(x_1),1);
  idv(id) = ones(length(id),1);
  nid = find(idv == 0);

  ## account for x_0
  id = id + p;
  nid = [(1:p)'; nid + p];

  A_id = A(:,id);
  A_nid = A(:,nid);

  x_id = -inv(A_id'*A_id) * A_id' * A_nid * x(nid);

end

assert((rows(x_id)==rows(id)) && (columns(x_id)==1));
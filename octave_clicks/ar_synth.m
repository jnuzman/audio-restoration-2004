## AR_SYNTH given AR coeffs and resid, synthesize process

function [x] = ar_synth(a, resid, x_init)

## handle p=0 assert(isvector(a) && (columns(a)==1));
assert(columns(a)==1);
assert(isvector(resid) && (columns(resid)==1));
assert((rows(x_init)==rows(a)) && (columns(x_init)==1));

if (rows(a)==0)
  x = resid;
  return;
end

## checkme: do i interpret the state vector correctly?
##NO x = filter(1, [1; -a], resid, x_init);

x_temp = [x_init; zeros(length(resid), 1)];
a_rev = flipud(a);

p = rows(a);

for out = 1:length(resid)
  x_temp(p+out) = resid(out) + dot(x_temp(out:out+p-1),a_rev);
end
  

x = x_temp(p+1:p+length(resid));

assert((rows(x)==rows(resid))&&(columns(x)==1));
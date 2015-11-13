## MAKEPOSTWIN produce post-window given pre-window

## ref DAR 6.1

function [postwin] = makepostwin(prewin, overlap_fact)

assert(isvector(prewin) && (columns(prewin)==1));
assert(isscalar(overlap_fact) && (round(overlap_fact)==overlap_fact));
assert((overlap_fact >= 2) && (overlap_fact <= length(prewin)));

## this simplifies things
assert(round(length(prewin)/overlap_fact)==(length(prewin)/overlap_fact));

## the seq is:  prewin -> FFT/IFFT -> postwin
## where postwin is equiv to:  prewin (for continuity) -> gain_comp
## so to determine gain_comp, we apply prewin twice

n = length(prewin);

prewin = reshape(prewin, n/overlap_fact, overlap_fact); 

sqrpre = prewin.*prewin;

winsums = sum(sqrpre, 2); #across rows, checkme dimensions

gain_comp = 1 ./ winsums;

## combine the post-fft prewin with the gain_comp into one step
for k=1:overlap_fact
  postwin(:,k) = prewin(:,k) .* gain_comp; #checkme dimensions
end

postwin = reshape(postwin, n, 1);


assert((rows(postwin)==n) && (columns(postwin)==1));

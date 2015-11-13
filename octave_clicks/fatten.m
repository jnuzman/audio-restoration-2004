function [fatidv] = fatten(thinidv, width_pre, width_post)

fatidv = zeros(rows(thinidv),1);

idv = [zeros(width_post,1); thinidv; zeros(width_pre,1)];

for k=1:length(thinidv)
  fatidv(k) = any(idv(k:k+width_pre+width_post));
end


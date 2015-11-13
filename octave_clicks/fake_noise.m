function [id noise] = fake_noise(len, p00, p11, alpha_v, beta_v)

r = rand(len, 1);  # uniform [0,1]

id = zeros(len, 1);
noise = zeros(len,1);

## estimate prob of single sample without knowing others
## derived this myself by assuming this is stationary
p01 = 1 - p00;
p10 = 1 - p11;
p0 = p10 ./ (p01 + p10);

id(1) = r(1) > p0;

for k=2:len
  if (id(k-1) == 0)
    id(k) = r(k) > p00;
  else
    id(k) = r(k) > p10;
  end
end

count = sum(id);

var_v = 1 ./ gamma_rnd(alpha_v, beta_v, count, 1);

## do this because i work with signals on [-1,1] scale rather than
## [-32768,32767]
var_v = var_v ./ (32768^2);

v = normal_rnd(zeros(count,1),var_v);

noise(id > 0) = v;


function p1 = binary_markov_prob(p00, p11)

p01 = 1 - p00;
p10 = 1 - p11;

p1 = p01 ./ (p01 + p10);

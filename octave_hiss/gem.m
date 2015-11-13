function [G_db] = gem(R_post_db, R_prio_db)

R_post = 10.^(R_post_db ./ 10);
R_prio = 10.^(R_prio_db ./ 10);

theta = (1 + R_post) .* (R_prio ./ (1 + R_prio));
halftheta = theta./2;

M = exp(- halftheta) .* \
    ( (1+theta).*besseli(0,halftheta) + theta.*besseli(1,halftheta));

G = sqrt(pi)/2 .* \
    sqrt( (1./(1+R_post)) .* (R_prio ./ (1 + R_prio)) ) .* M;

G_db = 20 .* log10(G);
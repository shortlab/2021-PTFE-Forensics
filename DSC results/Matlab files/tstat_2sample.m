function [t,dof] = tstat_2sample(m_a,st_a,n_a,m_b,st_b,n_b)
% Given the mean, standard deviation, and number of samples for two
% measurements, gives the t statistic and degrees of freedom assuming
% measurements are unpaired with unequal variances.
% Equations summarized here: https://www.statsdirect.co.uk/help/parametric_methods/utt.htm
% Note that the site above mentions the applicability of the t-test if the
% variances are significantly different, and I did check the ones I am
% mainly testing over on this site and they were all basically good (with
% 95% confidence). https://www.statskingdom.com/220VarF2.html
% Input: m_a, st_a, n_a - the mean, standard deviation, and sample number
% of the first set of data. m_b, st_b, n_b - the same for the second set.
% Output: t - t statistic, dof - calculated degrees of freedom 

t = (m_a-m_b)/sqrt(st_a^2/n_a+st_b^2/n_b);
dof = (st_a^2/n_a+st_b^2/n_b)^2/(((st_a^2/n_a)^2/(n_a-1))+((st_b^2/n_b)^2/(n_b-1)));

end
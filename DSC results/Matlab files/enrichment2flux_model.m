function [flux] = enrichment2flux_model(enrich)
% Given an enrichment, returns the flux (per year) based on the
% semi-empirical model and centrifuge assumptions.
% Methodology: Calculates directly from semi-empirical model
% Input: U-235 enrichment in [%], i.e. 5 for 5% enriched. If enrich is given
% as a vector, the output should be a vector with the matching fluxes.
% Output: Flux in [alphas/cm2/year]

%% The model parameters:
d = 5; % cm pipe diameter
Ntot =  1.61e18; % molecular density from ideal gas law
t234 = 2.5e5; % half life in years
t235 = 7.1e8;
t238 = 4.5e9;
a5 = 1.4; % separation factor for u-235
R_t_235 = 0.0072/(1-0.0072-0.000055); % Point for natU, 235
R_t_234 = 0.000055/(1-0.0072-0.000055); % Point for natU, 234
N0 = log(0.93/(1-0.93-0.01)/R_t_235)/log(a5); % Calc N from U-235 and point for 93%
a4 = (0.01/(1-0.93-0.01)/R_t_234)^(1/N0); % semi-empirical corresponding a4
pow = log(a4)/log(a5); % pre calc this for later.

%% Calculate f234
f235 = enrich/100;
C = 1/f235^pow*R_t_235^pow/R_t_234;
syms x;
eq = x*(1-x-f235)^(pow-1) == 1/C;
S = vpasolve(eq,x);
f234 = S;
f238 = 1-f234-f235;

%% Calculate total expected fluence

% flux per year
flux_234 = d/4*log(2)*(f234/t234).*Ntot;
flux_235 = d/4*log(2)*(f235/t235).*Ntot;
flux_238 = d/4*log(2)*(f238/t238).*Ntot;
flux_temp = flux_234+flux_235+flux_238;
flux = double(flux_temp);

end


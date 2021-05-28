%% Instructions:
% Since I have kept the attempted models as well, to run, should run by
% sections, and do General Values, Semi-Empriical - Complicated, Purely
% Empirical, and Fluence to reproduce figure.

%% General values

% 5 cm pipe diameter
d = 5;

% half lives
t234 = 2.5e5;
t235 = 7.1e8;
t238 = 4.5e9;

% enrichment or fractions and separation factors
f235 = 0.01*linspace(0.72,95,200);
% f235 = 0.01*linspace(0.72,95,23571);



a5 = 1.4;
a4  = 1+4/3*(a5-1);     %Wood    --- supposed to be better
% a4 = a5^(4/3);        %Von Halle

%% Original Model
% subscript t for tails and p for product

% Initial abundance ratios
R_t_235 = 0.0072/(1-0.0072);
R_t_234 = 0.000055/(1-0.000055);

for i = 1:length(f235)
    R_p_235 = f235(i)/(1-f235(i));
    N = log(R_p_235/R_t_235)/log(a5);
    R_p_234 = a4^N*R_t_234;
    f234(i) = R_p_234/(1+R_p_234);
end

% f238 = 1-f235-f234; % Constrained
% f238 = 1-f235; % Unconstrained

f234_basic = f234;

%% Simple model: neglect most instances of f234 compared to 235 and 238:

% Initial abundance ratios
R_t_235 = 0.0072/(1-0.0072);
R_t_234 = 0.000055/(1-0.0072);

for i = 1:length(f235)
    R_p_235 = f235(i)/(1-f235(i));
    N = log(R_p_235/R_t_235)/log(a5);
    R_p_234 = a4^N*R_t_234;
    f234(i) = R_p_234*(1-f235(i));
end

% f238 = 1-f235-f234; % Constrained
% f238 = 1-f235; % Unconstrained
f234_mod = f234;

%% Complicated model: 

R_t_235 = 0.0072/(1-0.0072-0.000055);
R_t_234 = 0.000055/(1-0.0072-0.000055);

pow = log(a4)/log(a5);
f234 = [];
for i = 1:length(f235)
    C = 1/f235(i)^pow*R_t_235^pow/R_t_234;
    syms x;
    eq = x*(1-x-f235(i))^(pow-1) == 1/C;
    S = vpasolve(eq,x);
    if isreal(S)
        f234(i) = S;
        f238(i) = 1-f235(i)-f234(i);
    else
        break;
    end
end
f234_com = f234;
f235_com = f235(1:length(f234)); % resize f235


%% Semi-empirical model

R_t_235 = 0.0072/(1-0.0072);
R_t_234 = 0.000055/(1-0.0072);

N0 = log(0.93/(1-0.93)/R_t_235)/log(a5);
a4_emp = (0.01/(1-0.93)/R_t_234)^(1/N0); % semi-empirical

for i = 1:length(f235)
    R_p_235 = f235(i)/(1-f235(i));
    N = log(R_p_235/R_t_235)/log(a5);
    R_p_234 = a4_emp^N*R_t_234;
    f234(i) = R_p_234*(1-f235(i));
end
% f238 = 1-f235-f234; % Constrained
% f238 = 1-f235; % Unconstrained

f234_se = f234;

%% Semi-empirical - complicated
% At 93% U-235, U-234 is about 1%

R_t_235 = 0.0072/(1-0.0072-0.000055);
R_t_234 = 0.000055/(1-0.0072-0.000055);

N0 = log(0.93/(1-0.93-0.01)/R_t_235)/log(a5);
a4 = (0.01/(1-0.93-0.01)/R_t_234)^(1/N0); % semi-empirical
pow = log(a4)/log(a5);
f234 = [];

for i = 1:length(f235)
    C = 1/f235(i)^pow*R_t_235^pow/R_t_234;
    syms x;
    eq = x*(1-x-f235(i))^(pow-1) == 1/C;
    S = vpasolve(eq,x);
    if isreal(S)
        f234(i) = S;
        f238(i) = 1-f235(i)-f234(i);
    else
        break;
    end
end
% f238 = 1-f235-f234; % Constrained
% f238 = 1-f235; % Unconstrained

f234_secom = f234;
f235_secom = f235(1:length(f234));

%% Purely emperical:

f4 = [0.000382 0.00995 0.009];
f5 = [0.04398 0.9316 0.923];
f8 = 1-f4-f5; 

% Fischer, 2006, Conference paper projections:
% Last point is for single cascade
f4_sim = [0.0054 0.0371 0.2066 0.7493 1.1281 0.0054 0.8871]/100;
f5_sim = [0.72 4 20 65 90 0.72 90]/100;
f8_sim = 1- f4_sim-f5_sim;

%% Plot U-234 Enrichment comparison

semilogy(f235*100,f234_basic*100,'-.','Color', [0    0.4470    0.7410])
hold on
semilogy(f235*100,f234_mod*100,':','Color', [0    0.4470    0.7410])
semilogy(f235_com*100,f234_com*100,'-','Color', [0    0.4470    0.7410])
% semilogy(f235*100,f234_se*100)
semilogy(f235_secom*100,f234_secom*100,'--','Color', [0    0.4470    0.7410])  % Overlaps with 

% Literature data added now.
semilogy(f5*100,f4*100,'kp')
semilogy(f5_sim(1:5)*100,f4_sim(1:5)*100,'ks')
semilogy(f5_sim(6:7)*100,f4_sim(6:7)*100,'kd')

% Set Axis stuff

h = zeros(7, 1);
h(1) = plot(NaN,NaN,'-.','Color', [0    0.4470    0.7410]);
h(2) = plot(NaN,NaN,':','Color', [0    0.4470    0.7410]);
h(3) = plot(NaN,NaN,'-','Color', [0    0.4470    0.7410]);
h(4) = plot(NaN,NaN,'--','Color', [0    0.4470    0.7410]);
h(5) = plot(NaN,NaN,'kp');
h(6) = plot(NaN,NaN,'ks');
h(7) = plot(NaN,NaN,'kd');

leg = legend(h,...
    'Assume f_{234} & f_{235} << f_{238}',...
    'Assume f_{234} << f_{235} & f_{238}',...
    'Constrain 1 = f_{234} + f_{235} + f_{238}',...
    'Semi-Empirical Model',...
    'Experimental Data*',...
    'Sim. (multiple cascades)**',...
    'Sim. (single cascade)**',...
    'Location','eastoutside');
set(leg, 'Units', 'pixels')
legs = get(leg, 'Position');
set(gcf,'Position',[100 50 700 525]+[0 0 legs(3) 0])%Make entire figure bigger
% title('Comparison of U-234 enrichment models')

ax1 = gca; % Bottom horizontal axes
set(ax1,...
        'FontUnits','points',...
        'FontWeight','normal',...
        'FontSize',16,...
        'FontName','Helvetica',...
        'LineWidth',1.25,...
        'XColor', 'k',...
        'YColor', 'k')
ylabel({'^{234}U % Enrichment'},...
        'FontUnits','points',...
        'FontSize',20,...
        'FontName','Helvetica')
xlabel({'^{235}U % Enrichment'},...
        'FontUnits','points',...
        'FontSize',20,...
        'FontName','Helvetica')
set(findall(gca, 'Type', 'Line'),'LineWidth',2) %Update all linewidths
set(findall(gca, 'Type', 'Line'),'MarkerSize',10) %Update all marker sizes
set(ax1, 'XLim',[-3,103]) %Add padding on left side  

yticks([1e-3 1e-2 0.1 1 10 100])
yticklabels({'0.001','0.01','0.1','1','10','100'})



%% Fluence

% average molecular weight
% MW = f235*(235+6*19)+f238*(238+6*19)+f234*(234+6*19);

% ultimately based on P=50torr and T=300K [kemp, 2009]
%Ntot = 0.00094*6.02e23./MW;
Ntot =  1.61e18;

% flux per year
flux_234 = d/4*log(2)*(f234/t234).*Ntot;
flux_235 = d/4*log(2)*(f235/t235).*Ntot;
flux_238 = d/4*log(2)*(f238/t238).*Ntot;
flux_tot = flux_234+flux_235+flux_238;

% plot
figure;
semilogy(f235*100,flux_234,'Color', [0    0.4470    0.7410])
hold on
semilogy(f235*100,flux_235,'Color', [0.8500    0.3250    0.0980])
semilogy(f235*100,flux_238,'Color', [0.9290    0.6940    0.1250])
semilogy(f235*100,flux_tot,'Color', [0 0 0])

% Empirical (Rademacher, Lovelace, Miller et al)
flux_4 = d/4*log(2)*(f4/t234).*Ntot;
flux_5 = d/4*log(2)*(f5/t235).*Ntot;
flux_8 = d/4*log(2)*(f8/t238).*Ntot;
flux_t = flux_4+flux_5+flux_8;
plot(f5*100, flux_t,'ks','MarkerFaceColor','k')

% Simulated (Fischer)
flux_4s = d/4*log(2)*(f4_sim/t234).*Ntot;
flux_5s = d/4*log(2)*(f5_sim/t235).*Ntot;
flux_8s = d/4*log(2)*(f8_sim/t238).*Ntot;
flux_ts = flux_4s+flux_5s+flux_8s;
plot(f5_sim(1:5)*100, flux_ts(1:5),'ks','MarkerFaceColor','k')
plot(f5_sim(6:7)*100, flux_ts(6:7),'ks','MarkerFaceColor','k')

h = zeros(2, 1);
h(1) = plot(NaN,NaN,'k');
h(2) = plot(NaN,NaN,'ks','MarkerFaceColor','k');
% h(3) = plot(NaN,NaN,'ks');
% h(4) = plot(NaN,NaN,'kd');

ax1 = gca; % Bottom horizontal axes
set(ax1,...
        'FontUnits','points',...
        'FontWeight','normal',...
        'FontSize',16,...
        'FontName','Helvetica',...
        'LineWidth',1.25,...
        'XColor', 'k',...
        'YColor', 'k')
ylabel({'Flux (\alpha/cm^2/yr)'},...
        'FontUnits','points',...
        'FontSize',20,...
        'FontName','Helvetica')
xlabel({'^{235}U % Enrichment'},...
        'FontUnits','points',...
        'FontSize',20,...
        'FontName','Helvetica')
set(findall(gca, 'Type', 'Line'),'LineWidth',2) %Update all linewidths
set(findall(gca, 'Type', 'Line'),'MarkerSize',7) %Update all marker sizes
set(ax1, 'XLim',[-3,103]) %Add padding on left side    
    
yyaxis right
ax2 = gca;
set(ax2,'YScale','log') 
% Add in deposited energy (Gy) in irrad. region by U-234
C = 1.6e-13*4.76*1000/2.2/21.3*10^4/1000;
dep = flux_234*C; %kGY
semilogy(f235*100,dep,'Color', [0    0.4470    0.7410])    

set(ax2,...
        'FontUnits','points',...
        'FontWeight','normal',...
        'FontSize',16,...
        'FontName','Helvetica',...
        'LineWidth',1.25,...
        'YLim', [10^7*C 10^11*C],...
        'XColor', 'k',...
        'YColor', [0    0.4470    0.7410])
ylabel({'^{234}U yearly dose (kGy/yr)'},...
        'FontUnits','points',...
        'FontSize',20,...
        'FontName','Helvetica')
    
leg = legend(h,...
    'Total Predicted Flux',...
    'Prior Literature \it{(43-46)}',...
    'Location','south');
% set(leg, 'Units', 'pixels')
% legs = get(leg, 'Position');
% set(gcf,'Position',[100 50 700 525]+[0 0 legs(3) 0])%Make entire figure bigger

yticks([1e-2 1e-1 1e0 1e1])







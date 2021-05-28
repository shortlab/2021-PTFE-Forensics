%% SRIM plots for damage profiles

%% Load Data
load('SRIMs.mat')

%% Deconvolve and sum vac, ions by recoil/direct

d_iz = ioniz(:,1)/1e4;
iz = ioniz(:,2)+ioniz(:,3);

d_vz = vacz(:,1)/1e4;
vz = vacz(:,2)+vacz(:,3);

%% Plot

figure;
hold on
yyaxis left;
plot(d_iz,iz,'LineWidth',3)
ylim([-3.5,35])
ylabel('Energy loss[ev/angstrom]')
ax1 = gca; 
set(ax1,...
        'FontUnits','points',...
        'FontWeight','normal',...
        'FontSize',16,...
        'FontName','Helvetica',...
        'LineWidth',2,...
        'XColor', 'k',...
        'YColor', 'k')
xlabel({'Depth [\mum]'},...
        'FontUnits','points',...
        'FontSize',20,...
        'FontName','Helvetica')
yyaxis right;
plot(d_vz,vz,'LineWidth',3) 
ylim([-0.001,0.01])
ylabel('vacancy/angstrom-ion')


%% Plot Without vacancy/nuclear stopping

figure;
hold on
plot(d_iz,iz,'k','LineWidth',3)
ylim([-3.5,35])
ylabel(['Energy loss (eV/' char(197) ')'])
ax1 = gca; 
set(ax1,...
        'FontUnits','points',...
        'FontWeight','normal',...
        'FontSize',16,...
        'FontName','Helvetica',...
        'LineWidth',2,...
        'XColor', 'k',...
        'YColor', 'k',...
        'Box', 'on')
xlabel({'Depth (\mum)'},...
        'FontUnits','points',...
        'FontSize',20,...
        'FontName','Helvetica')
xlim([0,32])



%% Convert SRIM to expected profile based on Cooling analysis data

load('coolAnalysis.mat')

% Portion of 1e11 enthalpy attributable to radiation damage:
sumtot = (Int_mean(5)*50-Int_mean(1)*30)/20;

% Total area under ionization curve
TA = trapz(d_iz,iz);

% Fractional ionization curve: curve area per half-micron per total area
for i = 1:length(d_iz)-1
   f_iz(i) = (iz(i+1)+iz(i))/2*(d_iz(i+1)-d_iz(i))/TA; 
end

% Weight appropriately
profile = (Int_mean(5)-Int_mean(1))*f_iz*50+Int_mean(1);

figure;
plot(d_iz(2:end),profile)









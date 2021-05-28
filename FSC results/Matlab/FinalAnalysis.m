%% All the Flash DSC Class-irradiated samples analyzed

% Data previously formatted.
% Load data: cool3-iso-heat4
% Get masses by Cp Method (and take mean)
% Get masses by hook method
% Get integrals by spline baseline
% Normalize integrals by mass (cp method)
% Process outliers based on isotherm damping
% Plot enthalpy vs slice number (+/- outliers) 
% Add in expected result based on Macro DSC
% Check masses: compare both methods, look at mass vs. slice number
% Decide on how to approach error bars

%% Notes to self.
% Need Class2 and Class1 Data formatted and loaded.
% Can interpolate to get better values of Cp for hook-mass estimate.
% Attempt hook-mass estimate on start-up hook on heat4.
% Try Cp-mass method with macro-DSC data (different stock material though)
% Try outlier algorithm, but normalize by mass first.

%% Load Data
% Cool3, Heat4, and isotherm before Cool3

load('formattedData.mat')              % Original class5 data
load('formattedData_again.mat')        % Chips 43 and 44 for class5 
load('Class3Data.mat')                 % Original Class3 data
load('Class4Data.mat')                 % Original Class4 data
load('isoRaw.mat')                     % Isotherm data for Class5/4/3
load('Class2Data.mat')                % Class2, includes Isotherm
load('class1data.mat')                % Class1, includes Isotherm

%% Data on cp from literature
% (Wunderlich, 1970) - Heat capacities of linear high polymers, pp. 331-335

T_K = [360; 370; 380; 390; 400; 425; 450];
Cp_caldegmol = [12.25; 12.4; 12.6; 12.7; 12.9; 13.4; 13.8];
nLit = length(T_K);

% convert to T [deg C], Cp specific [mJ/C/mg]
T_lit = T_K-273.15;
Cp_lit = Cp_caldegmol*4.184/50.01;

% Approximate Cp at T = 40 C and 375 C
Cp_40C = 11.75*4.184/50.01;
Cp_375C = 16.6*4.184/50.01;

%% Masses from function Cp_to_Mass to get each masses [ng] at T_lit

% Call my mass function:

masses_oc = Cp_to_Mass(T_oc_cool3,Q_oc_cool3,T_oc_heat4,Q_oc_heat4,x_oc);
masses_ocrc = Cp_to_Mass(T_ocrc_cool3,Q_ocrc_cool3,T_ocrc_heat4,Q_ocrc_heat4,x_ocrc);
masses_nc = Cp_to_Mass(T_nc_cool3,Q_nc_cool3,T_nc_heat4,Q_nc_heat4,x_nc);
masses_ncrc = Cp_to_Mass(T_ncrc_cool3,Q_ncrc_cool3,T_ncrc_heat4,Q_ncrc_heat4,x_ncrc);
masses_43 = Cp_to_Mass(T_43_cool3,Q_43_cool3,T_43_heat4,Q_43_heat4,x_43);
masses_44 = Cp_to_Mass(T_44_cool3,Q_44_cool3,T_44_heat4,Q_44_heat4,x_44);
masses_74 = Cp_to_Mass(T_74_cool3,Q_74_cool3,T_74_heat4,Q_74_heat4,x_74);
masses_75 = Cp_to_Mass(T_75_cool3,Q_75_cool3,T_75_heat4,Q_75_heat4,x_75);
masses_76 = Cp_to_Mass(T_76_cool3,Q_76_cool3,T_76_heat4,Q_76_heat4,x_76);
masses_77 = Cp_to_Mass(T_77_cool3,Q_77_cool3,T_77_heat4,Q_77_heat4,x_77);
masses_c4x = Cp_to_Mass(T_c4x_cool3,Q_c4x_cool3,T_c4x_heat4,Q_c4x_heat4,x_c4x);
masses_78 = Cp_to_Mass(T_78_cool3,Q_78_cool3,T_78_heat4,Q_78_heat4,x_78);
masses_c3x = Cp_to_Mass(T_c3x_cool3,Q_c3x_cool3,T_c3x_heat4,Q_c3x_heat4,x_c3x);
masses_79 = Cp_to_Mass(T_79_cool3,Q_79_cool3,T_79_heat4,Q_79_heat4,x_79);
masses_80 = Cp_to_Mass(T_80_cool3,Q_80_cool3,T_80_heat4,Q_80_heat4,x_80);

mass_oc = mean(masses_oc);
mass_ocrc = mean(masses_ocrc);
mass_nc = mean(masses_nc);
mass_ncrc = mean(masses_ncrc);
mass_43 = mean(masses_43);
mass_44 = mean(masses_44);
mass_74 = mean(masses_74);
mass_75 = mean(masses_75);
mass_76 = mean(masses_76);
mass_77 = mean(masses_77);
mass_c4x = mean(masses_c4x);
mass_78 = mean(masses_78);
mass_c3x = mean(masses_c3x);
mass_79 = mean(masses_79);
mass_80 = mean(masses_80);

%% Hook for comparison to mass:

hooks_oc = hook(T_oc_cool3,Q_oc_cool3,x_oc);
hooks_ocrc = hook(T_ocrc_cool3,Q_ocrc_cool3,x_ocrc);
hooks_nc = hook(T_nc_cool3,Q_nc_cool3,x_nc);
hooks_ncrc = hook(T_ncrc_cool3,Q_ncrc_cool3,x_ncrc);
hooks_43 = hook(T_43_cool3,Q_43_cool3,x_43);
hooks_44 = hook(T_44_cool3,Q_44_cool3,x_44);
hooks_74 = hook(T_74_cool3,Q_74_cool3,x_74);
hooks_75 = hook(T_75_cool3,Q_75_cool3,x_75);
hooks_76 = hook(T_76_cool3,Q_76_cool3,x_76);
hooks_77 = hook(T_77_cool3,Q_77_cool3,x_77);
hooks_c4x = hook(T_c4x_cool3,Q_c4x_cool3,x_c4x);
hooks_78 = hook(T_78_cool3,Q_78_cool3,x_78);
hooks_c3x = hook(T_c3x_cool3,Q_c3x_cool3,x_c3x);
hooks_79 = hook(T_79_cool3,Q_79_cool3,x_79);
hooks_80 = hook(T_80_cool3,Q_80_cool3,x_80);

%% Estimate mass from hooks

cool = 500;

hook_oc = hooks_oc/cool/Cp_375C*1e6;
hook_ocrc = hooks_ocrc/cool/Cp_375C*1e6;
hook_nc = hooks_nc/cool/Cp_375C*1e6;
hook_ncrc = hooks_ncrc/cool/Cp_375C*1e6;
hook_43 = hooks_43/cool/Cp_375C*1e6;
hook_44 = hooks_44/cool/Cp_375C*1e6;
hook_74 = hooks_74/cool/Cp_375C*1e6;
hook_75 = hooks_75/cool/Cp_375C*1e6;
hook_76 = hooks_76/cool/Cp_375C*1e6;
hook_77 = hooks_77/cool/Cp_375C*1e6;
hook_c4x = hooks_c4x/cool/Cp_375C*1e6;
hook_78 = hooks_78/cool/Cp_375C*1e6;
hook_c3x = hooks_c3x/cool/Cp_375C*1e6;
hook_79 = hooks_79/cool/Cp_375C*1e6;
hook_80 = hooks_80/cool/Cp_375C*1e6;

%% Integrals from spline baselines

ints_oc = Spline_Baseline_Integral(T_oc_cool3,Q_oc_cool3,x_oc);
ints_ocrc = Spline_Baseline_Integral(T_ocrc_cool3,Q_ocrc_cool3,x_ocrc);
ints_nc = Spline_Baseline_Integral(T_nc_cool3,Q_nc_cool3,x_nc);
ints_ncrc = Spline_Baseline_Integral(T_ncrc_cool3,Q_ncrc_cool3,x_ncrc);
ints_43 = Spline_Baseline_Integral(T_43_cool3,Q_43_cool3,x_43);
ints_44 = Spline_Baseline_Integral(T_44_cool3,Q_44_cool3,x_44);
ints_74 = Spline_Baseline_Integral(T_74_cool3,Q_74_cool3,x_74);
ints_75 = Spline_Baseline_Integral(T_75_cool3,Q_75_cool3,x_75);
ints_76 = Spline_Baseline_Integral(T_76_cool3,Q_76_cool3,x_76);
ints_77 = Spline_Baseline_Integral(T_77_cool3,Q_77_cool3,x_77);
ints_c4x = Spline_Baseline_Integral(T_c4x_cool3,Q_c4x_cool3,x_c4x);
ints_78 = Spline_Baseline_Integral(T_78_cool3,Q_78_cool3,x_78);
ints_c3x = Spline_Baseline_Integral(T_c3x_cool3,Q_c3x_cool3,x_c3x);
ints_79 = Spline_Baseline_Integral(T_79_cool3,Q_79_cool3,x_79);
ints_80 = Spline_Baseline_Integral(T_80_cool3,Q_80_cool3,x_80);

%% Normalize by mass, heating rate to convert to enthalpy
% 500 kps heating/cooling rate
rate = 500;

enth_oc = 1e6/rate*ints_oc./mass_oc;  
enth_ocrc = 1e6/rate*ints_ocrc./mass_ocrc;  
enth_nc = 1e6/rate*ints_nc./mass_nc;  
enth_ncrc = 1e6/rate*ints_ncrc./mass_ncrc;  
enth_43 = 1e6/rate*ints_43./mass_43;  
enth_44 = 1e6/rate*ints_44./mass_44; 
enth_74 = 1e6/rate*ints_74./mass_74;  
enth_75 = 1e6/rate*ints_75./mass_75;  
enth_76 = 1e6/rate*ints_76./mass_76;  
enth_77 = 1e6/rate*ints_77./mass_77;  
enth_c4x = 1e6/rate*ints_c4x./mass_c4x; 
enth_78 = 1e6/rate*ints_78./mass_78;  
enth_c3x = 1e6/rate*ints_c3x./mass_c3x;
enth_79 = 1e6/rate*ints_79./mass_79;  
enth_80 = 1e6/rate*ints_80./mass_80;  

%% Identify Outliers based on isotherm damping
th = 1.1;  % critically damped + an extra 10% overdamped for error in fit
% th = 1;

remOLs_oc = outliersID(T_oc_iso,Q_oc_iso,x_oc,th);
remOLs_ocrc = outliersID(T_ocrc_iso,Q_ocrc_iso,x_ocrc,th);
remOLs_nc = outliersID(T_nc_iso,Q_nc_iso,x_nc,th);
remOLs_ncrc = outliersID(T_ncrc_iso,Q_ncrc_iso,x_ncrc,th);
remOLs_43 = outliersID(T_43_iso,Q_43_iso,x_43,th);
remOLs_44 = outliersID(T_44_iso,Q_44_iso,x_44,th);
remOLs_74 = outliersID(T_74_iso,Q_74_iso,x_74,th);
remOLs_75 = outliersID(T_75_iso,Q_75_iso,x_75,th);
remOLs_76 = outliersID(T_76_iso,Q_76_iso,x_76,th);
remOLs_77 = outliersID(T_77_iso,Q_77_iso,x_77,th);
remOLs_c4x = outliersID(T_c4x_iso,Q_c4x_iso,x_c4x,th);
remOLs_78 = outliersID(T_78_iso,Q_78_iso,x_78,th);
remOLs_c3x = outliersID(T_c3x_iso,Q_c3x_iso,x_c3x,th);
remOLs_79 = outliersID(T_79_iso,Q_79_iso,x_79,th);
remOLs_80 = outliersID(T_80_iso,Q_80_iso,x_80,th);

%% Figures to create:
% Mass Cp vs Hook Comparison
% Prediction of signal based on macro-dsc
% Data +/- outliers
% Outlier explanation figure(s)

%% Figure: Mass comparison

figure;
hold on
plot(mass_80(remOLs_80),hook_80(remOLs_80),'mo')
plot(mass_79(remOLs_79),hook_79(remOLs_79),'yo')
plot(mass_78(remOLs_78),hook_78(remOLs_78),'bo')
plot(mass_c3x(remOLs_c3x),hook_c3x(remOLs_c3x),'b*')
plot(mass_77(remOLs_77),hook_77(remOLs_77),'ro')
plot(mass_76(remOLs_76),hook_76(remOLs_76),'r+')
plot(mass_75(remOLs_75),hook_75(remOLs_75),'rx')
plot(mass_74(remOLs_74),hook_74(remOLs_74),'r^')
plot(mass_c4x(remOLs_c4x),hook_c4x(remOLs_c4x),'r*')
plot(mass_43(remOLs_43),hook_43(remOLs_43),'g*')
plot(mass_44(remOLs_44),hook_44(remOLs_44),'go')
plot(mass_oc(remOLs_oc),hook_oc(remOLs_oc),'ko')
plot(mass_nc(remOLs_nc),hook_nc(remOLs_nc),'k*')
plot(mass_ocrc(remOLs_ocrc),hook_ocrc(remOLs_ocrc),'k+')
plot(mass_ncrc(remOLs_ncrc),hook_ncrc(remOLs_ncrc),'k^')

plot(linspace(50,500),linspace(50,500),'k--')
plot(linspace(50,500),0.95*linspace(50,500)+0.61,'k-.')
xlabel('mass by cp [ng]')
ylabel('mass by hook [ng]')

h = zeros(2, 1);
h(1) = plot(NaN,NaN,'k--');
h(2) = plot(NaN,NaN,'k-.');

legend(h, 'y = x','y = 0.95x + 0.61');



%% Look at all masses:

figure;
hold on
plot(x_oc(remOLs_oc),mass_oc(remOLs_oc),'bo')
plot(x_ocrc(remOLs_ocrc),mass_ocrc(remOLs_ocrc),'bo')
plot(x_nc(remOLs_nc),mass_nc(remOLs_nc),'bo')
plot(x_ncrc(remOLs_ncrc),mass_ncrc(remOLs_ncrc),'bo')
plot(x_43(remOLs_43),mass_43(remOLs_43),'bo')
plot(x_44(remOLs_44),mass_44(remOLs_44),'bo')
plot(x_c4x(remOLs_c4x),mass_c4x(remOLs_c4x),'go')
plot(x_74(remOLs_74),mass_74(remOLs_74),'go')
plot(x_75(remOLs_75),mass_75(remOLs_75),'go')
plot(x_76(remOLs_76),mass_76(remOLs_76),'go')
plot(x_77(remOLs_77),mass_77(remOLs_77),'go')
plot(x_c3x(remOLs_c3x),mass_c3x(remOLs_c3x),'ro')
plot(x_78(remOLs_78),mass_78(remOLs_78),'ro')
plot(x_79(remOLs_79),mass_79(remOLs_79),'ko')
plot(x_80(remOLs_80),mass_80(remOLs_80),'mo')

xlabel('Slice Number ~ depth [\mum]')
ylabel('Sample mass [ng]')
title('Sample masses by C_p method')
h = zeros(5, 1);
h(1) = plot(NaN,NaN,'bo');
h(2) = plot(NaN,NaN,'go');
h(3) = plot(NaN,NaN,'ro');
h(4) = plot(NaN,NaN,'ko');
h(5) = plot(NaN,NaN,'mo');

legend(h, 'set 5','set 4','set 3','set 2', 'set 1');

%% Enthalpy
figure;
hold on
plot(x_oc,enth_oc,'bo')
plot(x_ocrc,enth_ocrc,'bo')
plot(x_nc,enth_nc,'bo')
plot(x_ncrc,enth_ncrc,'bo')
plot(x_43,enth_43,'bo')
plot(x_44,enth_44,'bo')
plot(x_c4x,enth_c4x,'go')
plot(x_74,enth_74,'go')
plot(x_75,enth_75,'go')
plot(x_76,enth_76,'go')
plot(x_77,enth_77,'go')
plot(x_c3x,enth_c3x,'ro')
plot(x_78,enth_78,'ro')
plot(x_79,enth_79,'ko')
plot(x_80,enth_80,'mo')

xlabel('Slice Number ~ depth [\mum]')
ylabel('Recrystallizartion enthalpy [J/g]')
h = zeros(5, 1);
h(1) = plot(NaN,NaN,'bo');
h(2) = plot(NaN,NaN,'go');
h(3) = plot(NaN,NaN,'ro');
h(4) = plot(NaN,NaN,'ko');
h(5) = plot(NaN,NaN,'mo');
title('Before outlier identification')
legend(h, 'set 5','set 4','set 3','set 2', 'set 1');

%% Enthalpy - outliers removed
figure;

% load('coolAnalysis.mat')
% top = (Int_mean(5)*50-Int_mean(1)*25)/25;

hold on

% plot([0,20],[top top]-7,'y','LineWidth', 20)
% plot([20,32],[Int_mean(1) Int_mean(1)]-7,'y','LineWidth', 20)
% plot([0,20],[top top],'y','LineWidth', 20)
% plot([20,32],[Int_mean(1) Int_mean(1)],'y','LineWidth', 20)


plot(x_oc(remOLs_oc),enth_oc(remOLs_oc),'bo')
plot(x_ocrc(remOLs_ocrc),enth_ocrc(remOLs_ocrc),'bo')
plot(x_nc(remOLs_nc),enth_nc(remOLs_nc),'bo')
plot(x_ncrc(remOLs_ncrc),enth_ncrc(remOLs_ncrc),'bo')
plot(x_43(remOLs_43),enth_43(remOLs_43),'bo')
plot(x_44(remOLs_44),enth_44(remOLs_44),'bo')
plot(x_c4x(remOLs_c4x),enth_c4x(remOLs_c4x),'go')
plot(x_74(remOLs_74),enth_74(remOLs_74),'go')
plot(x_75(remOLs_75),enth_75(remOLs_75),'go')
plot(x_76(remOLs_76),enth_76(remOLs_76),'go')
plot(x_77(remOLs_77),enth_77(remOLs_77),'go')
plot(x_c3x(remOLs_c3x),enth_c3x(remOLs_c3x),'ro')
plot(x_78(remOLs_78),enth_78(remOLs_78),'ro')
plot(x_79(remOLs_79),enth_79(remOLs_79),'ko')
plot(x_80(remOLs_80),enth_80(remOLs_80),'mo')

xlabel('Slice Number ~ depth [\mum]')
ylabel('Recrystallizartion enthalpy [J/g]')
h = zeros(5, 1);
h(1) = plot(NaN,NaN,'bo');
h(2) = plot(NaN,NaN,'go');
h(3) = plot(NaN,NaN,'ro');
h(4) = plot(NaN,NaN,'ko');
h(5) = plot(NaN,NaN,'mo');
title('Outliers removed')
legend(h, 'set 5','set 4','set 3','set 2', 'set 1');

%% Average along slice number

enth_f_oc = enth_oc(remOLs_oc);
enth_f_ocrc = enth_ocrc(remOLs_ocrc);
enth_f_nc = enth_nc(remOLs_nc);
enth_f_ncrc = enth_ncrc(remOLs_ncrc);
enth_f_43 = enth_43(remOLs_43);
enth_f_44 = enth_44(remOLs_44);
enth_f_c4x = enth_c4x(remOLs_c4x);
enth_f_74 = enth_74(remOLs_74);
enth_f_75 = enth_75(remOLs_75);
enth_f_76 = enth_76(remOLs_76);
enth_f_77 = enth_77(remOLs_77);
enth_f_c3x = enth_c3x(remOLs_c3x);
enth_f_78 = enth_78(remOLs_78);
enth_f_79 = enth_79(remOLs_79);
enth_f_80 = enth_80(remOLs_80);

x_f_oc = x_oc(remOLs_oc);
x_f_ocrc = x_ocrc(remOLs_ocrc);
x_f_nc = x_nc(remOLs_nc);
x_f_ncrc = x_ncrc(remOLs_ncrc);
x_f_43 = x_43(remOLs_43);
x_f_44 = x_44(remOLs_44);
x_f_c4x = x_c4x(remOLs_c4x);
x_f_74 = x_74(remOLs_74);
x_f_75 = x_75(remOLs_75);
x_f_76 = x_76(remOLs_76);
x_f_77 = x_77(remOLs_77);
x_f_c3x = x_c3x(remOLs_c3x);
x_f_78 = x_78(remOLs_78);
x_f_79 = x_79(remOLs_79);
x_f_80 = x_80(remOLs_80);

enth_cat = cat(2,...
    enth_f_oc,...
    enth_f_ocrc,...
    enth_f_nc,...
    enth_f_ncrc,...
    enth_f_43,...
    enth_f_44,...
    enth_f_c4x,...
    enth_f_74,...
    enth_f_75,...
    enth_f_76,...
    enth_f_77,...
    enth_f_c3x,...
    enth_f_78,...
    enth_f_79,...
    enth_f_80);

x_cat = cat(2,...
    x_f_oc,...
    x_f_ocrc,...
    x_f_nc,...
    x_f_ncrc,...
    x_f_43,...
    x_f_44,...
    x_f_c4x,...
    x_f_74,...
    x_f_75,...
    x_f_76,...
    x_f_77,...
    x_f_c3x,...
    x_f_78,...
    x_f_79,...
    x_f_80);

% per individual x value
e_avg = zeros(1,32);
e_std = zeros(1,32);
% smoothed over 3 x values 
e_s3_avg = zeros(1,30);
e_s3_std = zeros(1,30); 
% smoothed over 5 x values 
e_s5_avg = zeros(1,28);
e_s5_std = zeros(1,28);
% smoothed over 2 x values
e_s2_avg = zeros(1,28);
e_s2_std = zeros(1,28);
x_master = 1:32;

for i = 1:32
    vals = enth_cat(x_cat==i);
    e_avg(i) = mean(vals);
    e_std(i) = std(vals);
end
for i = 2:31
    vals = [enth_cat(x_cat==i-1) enth_cat(x_cat==i) enth_cat(x_cat==i+1)];
    e_s3_avg(i-1) = mean(vals);
    e_s3_std(i-1) = std(vals);
end
for i = 3:30
    vals = [enth_cat(x_cat==i-2) enth_cat(x_cat==i-1) enth_cat(x_cat==i) enth_cat(x_cat==i+1) enth_cat(x_cat==i+2)];
    e_s5_avg(i-2) = mean(vals);
    e_s5_std(i-2) = std(vals);
end
for i = 2:32
    vals = [enth_cat(x_cat==i-1) enth_cat(x_cat==i)];
    e_s2_avg(i-1) = mean(vals);
    e_s2_std(i-1) = std(vals);
end

%% Get facets for plotting (pure average/std by depth)

% Guess based on Macro DSC, in MacroDSC colors
load('coolAnalysis.mat')

x_a = 1;
x_b = 20;
x_c = 32;

% Correct for half-ish damage
corr = (Int_mean(5)*50-Int_mean(1)*(50-x_b))/x_b;
const = 7;

u_1 = corr-Int_mean(5)+Int_plus2S(5)-const;
u_2 = corr-Int_mean(5)+Int_plus1S(5)-const;
u_3 = corr-Int_mean(5)+Int_minus1S(5)-const;
u_4 = corr-Int_mean(5)+Int_minus2S(5)-const;
d_1 = Int_plus2S(1)-const;
d_2 = Int_plus1S(1)-const;
d_3 = Int_minus1S(1)-const;
d_4 = Int_minus2S(1)-const;

v_1 = [x_a,u_4; x_a,u_1; x_b,u_1; x_b,u_4]; 
v_2 = [x_a,u_3; x_a,u_2; x_b,u_2; x_b,u_3];
v_3 = [x_b,d_4; x_b,d_1; x_c,d_1; x_c,d_4];
v_4 = [x_b,d_3; x_b,d_2; x_c,d_2; x_c,d_3]; 

f_a = [1 2 3 4];

% Faces and vertices for mean and 2 stds of slice data

v_2S = [x_master , x_master; e_avg-2*e_std, e_avg+2*e_std].';
v_1S = [x_master , x_master; e_avg-e_std, e_avg+e_std].';

f = zeros(31,4);
for i = 1:31
    f(i,:) = [i,32+i,33+i,i+1];
end

%% Figure: pure average/std by depth

figure;
hold on

% Plot mean with error shading (grey)
patch('Faces',f,'Vertices', v_2S,'FaceColor',[211/255 211/255 211/255],'EdgeColor','none','FaceAlpha', 0.3)
patch('Faces',f,'Vertices', v_1S,'FaceColor',[169/255 169/255 169/255],'EdgeColor','none','FaceAlpha', 0.3)
plot(x_master,e_avg,'k','LineWidth',2)

% Plot bars for expected values based on macroDSC
patch('Faces',f_a,'Vertices', v_1,'FaceColor',[204/255 229/255 255/255],'EdgeColor','none','FaceAlpha', 0.5)
patch('Faces',f_a,'Vertices', v_2,'FaceColor',[153/255 204/255 255/255],'EdgeColor','none','FaceAlpha', 0.5)
patch('Faces',f_a,'Vertices', v_3,'FaceColor',[204/255 229/255 255/255],'EdgeColor','none','FaceAlpha', 0.5)
patch('Faces',f_a,'Vertices', v_4,'FaceColor',[153/255 204/255 255/255],'EdgeColor','none','FaceAlpha', 0.5)
plot([x_a x_b], [corr corr]-const, 'b-','LineWidth',1)
plot([x_b x_c], [Int_mean(1) Int_mean(1)]-const, 'b-','LineWidth',1)

% Plot raw data
plot(x_oc(remOLs_oc),enth_oc(remOLs_oc),'bo')
plot(x_ocrc(remOLs_ocrc),enth_ocrc(remOLs_ocrc),'bo')
plot(x_nc(remOLs_nc),enth_nc(remOLs_nc),'bo')
plot(x_ncrc(remOLs_ncrc),enth_ncrc(remOLs_ncrc),'bo')
plot(x_43(remOLs_43),enth_43(remOLs_43),'bo')
plot(x_44(remOLs_44),enth_44(remOLs_44),'bo')
plot(x_c4x(remOLs_c4x),enth_c4x(remOLs_c4x),'go')
plot(x_74(remOLs_74),enth_74(remOLs_74),'go')
plot(x_75(remOLs_75),enth_75(remOLs_75),'go')
plot(x_76(remOLs_76),enth_76(remOLs_76),'go')
plot(x_77(remOLs_77),enth_77(remOLs_77),'go')
plot(x_c3x(remOLs_c3x),enth_c3x(remOLs_c3x),'ro')
plot(x_78(remOLs_78),enth_78(remOLs_78),'ro')
plot(x_79(remOLs_79),enth_79(remOLs_79),'ko')
plot(x_80(remOLs_80),enth_80(remOLs_80),'mo')

xlabel('Slice Number ~ depth [\mum]')
ylabel('Recrystallizartion enthalpy [J/g]')
h = zeros(5, 1);
h(1) = plot(NaN,NaN,'bo');
h(2) = plot(NaN,NaN,'go');
h(3) = plot(NaN,NaN,'ro');
h(4) = plot(NaN,NaN,'ko');
h(5) = plot(NaN,NaN,'mo');

legend(h, 'set 5','set 4','set 3','set 2', 'set 1');

%% Get facets for plotting (smoothed average/std by depth)

% Guess based on Macro DSC, in MacroDSC colors
load('coolAnalysis.mat')

x_a = 1;
x_b = 20;
x_c = 32;

% Correct for half-ish damage
corr = (Int_mean(5)*50-Int_mean(1)*(50-x_b))/x_b;
const = 7;

u_1 = corr-Int_mean(5)+Int_plus2S(5)-const;
u_2 = corr-Int_mean(5)+Int_plus1S(5)-const;
u_3 = corr-Int_mean(5)+Int_minus1S(5)-const;
u_4 = corr-Int_mean(5)+Int_minus2S(5)-const;
d_1 = Int_plus2S(1)-const;
d_2 = Int_plus1S(1)-const;
d_3 = Int_minus1S(1)-const;
d_4 = Int_minus2S(1)-const;

v_1 = [x_a,u_4; x_a,u_1; x_b,u_1; x_b,u_4]; 
v_2 = [x_a,u_3; x_a,u_2; x_b,u_2; x_b,u_3];
v_3 = [x_b,d_4; x_b,d_1; x_c,d_1; x_c,d_4];
v_4 = [x_b,d_3; x_b,d_2; x_c,d_2; x_c,d_3]; 

f_a = [1 2 3 4];

% Faces and vertices for mean and 2 stds of slice data
x_mister = 2:31;
v_2S = [x_mister , x_mister; e_s3_avg-2*e_s3_std, e_s3_avg+2*e_s3_std].';
v_1S = [x_mister , x_mister; e_s3_avg-e_s3_std, e_s3_avg+e_s3_std].';

f = zeros(29,4);
for i = 1:29
    f(i,:) = [i,30+i,31+i,i+1];
end

%% Figure: smoothed average/std by depth

% figure;
hold on

% Plot mean with error shading (grey)
patch('Faces',f,'Vertices', v_2S,'FaceColor',[144/255 238/255 144/255],'EdgeColor','none','FaceAlpha', 0.3)
patch('Faces',f,'Vertices', v_1S,'FaceColor',[60/255 179/255 113/255],'EdgeColor','none','FaceAlpha', 0.3)
plot(x_mister,e_s3_avg,'g','LineWidth',2)

% Plot bars for expected values based on macroDSC
patch('Faces',f_a,'Vertices', v_1,'FaceColor',[204/255 229/255 255/255],'EdgeColor','none','FaceAlpha', 0.5)
patch('Faces',f_a,'Vertices', v_2,'FaceColor',[153/255 204/255 255/255],'EdgeColor','none','FaceAlpha', 0.5)
patch('Faces',f_a,'Vertices', v_3,'FaceColor',[204/255 229/255 255/255],'EdgeColor','none','FaceAlpha', 0.5)
patch('Faces',f_a,'Vertices', v_4,'FaceColor',[153/255 204/255 255/255],'EdgeColor','none','FaceAlpha', 0.5)
plot([x_a x_b], [corr corr]-const, 'b-','LineWidth',1)
plot([x_b x_c], [Int_mean(1) Int_mean(1)]-const, 'b-','LineWidth',1)

% Plot raw data
plot(x_oc(remOLs_oc),enth_oc(remOLs_oc),'bo')
plot(x_ocrc(remOLs_ocrc),enth_ocrc(remOLs_ocrc),'bo')
plot(x_nc(remOLs_nc),enth_nc(remOLs_nc),'bo')
plot(x_ncrc(remOLs_ncrc),enth_ncrc(remOLs_ncrc),'bo')
plot(x_43(remOLs_43),enth_43(remOLs_43),'bo')
plot(x_44(remOLs_44),enth_44(remOLs_44),'bo')
plot(x_c4x(remOLs_c4x),enth_c4x(remOLs_c4x),'go')
plot(x_74(remOLs_74),enth_74(remOLs_74),'go')
plot(x_75(remOLs_75),enth_75(remOLs_75),'go')
plot(x_76(remOLs_76),enth_76(remOLs_76),'go')
plot(x_77(remOLs_77),enth_77(remOLs_77),'go')
plot(x_c3x(remOLs_c3x),enth_c3x(remOLs_c3x),'ro')
plot(x_78(remOLs_78),enth_78(remOLs_78),'ro')
plot(x_79(remOLs_79),enth_79(remOLs_79),'ko')
plot(x_80(remOLs_80),enth_80(remOLs_80),'mo')

xlabel('Slice Number ~ depth [\mum]')
ylabel('Recrystallizartion enthalpy [J/g]')
h = zeros(5, 1);
h(1) = plot(NaN,NaN,'bo');
h(2) = plot(NaN,NaN,'go');
h(3) = plot(NaN,NaN,'ro');
h(4) = plot(NaN,NaN,'ko');
h(5) = plot(NaN,NaN,'mo');

legend(h, 'set 5','set 4','set 3','set 2', 'set 1');


%% Get facets for plotting (over 5 - smoothed average/std by depth)

% Guess based on Macro DSC, in MacroDSC colors
load('coolAnalysis.mat')

x_a = 1;
x_b = 20;
x_c = 32;

% Correct for half-ish damage
corr = (Int_mean(5)*50-Int_mean(1)*(50-x_b))/x_b;
const = 7;

u_1 = corr-Int_mean(5)+Int_plus2S(5)-const;
u_2 = corr-Int_mean(5)+Int_plus1S(5)-const;
u_3 = corr-Int_mean(5)+Int_minus1S(5)-const;
u_4 = corr-Int_mean(5)+Int_minus2S(5)-const;
d_1 = Int_plus2S(1)-const;
d_2 = Int_plus1S(1)-const;
d_3 = Int_minus1S(1)-const;
d_4 = Int_minus2S(1)-const;

v_1 = [x_a,u_4; x_a,u_1; x_b,u_1; x_b,u_4]; 
v_2 = [x_a,u_3; x_a,u_2; x_b,u_2; x_b,u_3];
v_3 = [x_b,d_4; x_b,d_1; x_c,d_1; x_c,d_4];
v_4 = [x_b,d_3; x_b,d_2; x_c,d_2; x_c,d_3]; 

f_a = [1 2 3 4];

% Faces and vertices for mean and 2 stds of slice data
x_mis = 3:30;
v_2S = [x_mis , x_mis; e_s5_avg-2*e_s5_std, e_s5_avg+2*e_s5_std].';
v_1S = [x_mis , x_mis; e_s5_avg-e_s5_std, e_s5_avg+e_s5_std].';

f = zeros(27,4);
for i = 1:27
    f(i,:) = [i,28+i,29+i,i+1];
end

%% Figure: over 5 - smoothed average/std by depth

% figure;
hold on

% Plot mean with error shading (grey)
patch('Faces',f,'Vertices', v_2S,'FaceColor',[240/255 128/255 128/255],'EdgeColor','none','FaceAlpha', 0.3)
patch('Faces',f,'Vertices', v_1S,'FaceColor',[205/255 92/255 92/255],'EdgeColor','none','FaceAlpha', 0.3)
plot(x_mis,e_s5_avg,'r','LineWidth',2)

% Plot bars for expected values based on macroDSC
patch('Faces',f_a,'Vertices', v_1,'FaceColor',[204/255 229/255 255/255],'EdgeColor','none','FaceAlpha', 0.5)
patch('Faces',f_a,'Vertices', v_2,'FaceColor',[153/255 204/255 255/255],'EdgeColor','none','FaceAlpha', 0.5)
patch('Faces',f_a,'Vertices', v_3,'FaceColor',[204/255 229/255 255/255],'EdgeColor','none','FaceAlpha', 0.5)
patch('Faces',f_a,'Vertices', v_4,'FaceColor',[153/255 204/255 255/255],'EdgeColor','none','FaceAlpha', 0.5)
plot([x_a x_b], [corr corr]-const, 'b-','LineWidth',1)
plot([x_b x_c], [Int_mean(1) Int_mean(1)]-const, 'b-','LineWidth',1)

% Plot raw data
plot(x_oc(remOLs_oc),enth_oc(remOLs_oc),'bo')
plot(x_ocrc(remOLs_ocrc),enth_ocrc(remOLs_ocrc),'bo')
plot(x_nc(remOLs_nc),enth_nc(remOLs_nc),'bo')
plot(x_ncrc(remOLs_ncrc),enth_ncrc(remOLs_ncrc),'bo')
plot(x_43(remOLs_43),enth_43(remOLs_43),'bo')
plot(x_44(remOLs_44),enth_44(remOLs_44),'bo')
plot(x_c4x(remOLs_c4x),enth_c4x(remOLs_c4x),'go')
plot(x_74(remOLs_74),enth_74(remOLs_74),'go')
plot(x_75(remOLs_75),enth_75(remOLs_75),'go')
plot(x_76(remOLs_76),enth_76(remOLs_76),'go')
plot(x_77(remOLs_77),enth_77(remOLs_77),'go')
plot(x_c3x(remOLs_c3x),enth_c3x(remOLs_c3x),'ro')
plot(x_78(remOLs_78),enth_78(remOLs_78),'ro')
plot(x_79(remOLs_79),enth_79(remOLs_79),'ko')
plot(x_80(remOLs_80),enth_80(remOLs_80),'mo')

xlabel('Slice Number ~ depth [\mum]')
ylabel('Recrystallizartion enthalpy [J/g]')
h = zeros(5, 1);
h(1) = plot(NaN,NaN,'bo');
h(2) = plot(NaN,NaN,'go');
h(3) = plot(NaN,NaN,'ro');
h(4) = plot(NaN,NaN,'ko');
h(5) = plot(NaN,NaN,'mo');

legend(h, 'set 5','set 4','set 3','set 2', 'set 1');

%% Get facets for plotting (over 2 - smoothed average/std by depth)

% Guess based on Macro DSC, in MacroDSC colors
load('coolAnalysis.mat')

x_a = 1;
x_b = 20;
x_c = 32;

% Correct for half-ish damage
corr = (Int_mean(5)*50-Int_mean(1)*(50-x_b))/x_b;
const = 7;

u_1 = corr-Int_mean(5)+Int_plus2S(5)-const;
u_2 = corr-Int_mean(5)+Int_plus1S(5)-const;
u_3 = corr-Int_mean(5)+Int_minus1S(5)-const;
u_4 = corr-Int_mean(5)+Int_minus2S(5)-const;
d_1 = Int_plus2S(1)-const;
d_2 = Int_plus1S(1)-const;
d_3 = Int_minus1S(1)-const;
d_4 = Int_minus2S(1)-const;

v_1 = [x_a,u_4; x_a,u_1; x_b,u_1; x_b,u_4]; 
v_2 = [x_a,u_3; x_a,u_2; x_b,u_2; x_b,u_3];
v_3 = [x_b,d_4; x_b,d_1; x_c,d_1; x_c,d_4];
v_4 = [x_b,d_3; x_b,d_2; x_c,d_2; x_c,d_3]; 

f_a = [1 2 3 4];

% Faces and vertices for mean and 2 stds of slice data
x_mist = 2:32;
v_2S = [x_mist-0.5 , x_mist-0.5; e_s2_avg-2*e_s2_std, e_s2_avg+2*e_s2_std].';
v_1S = [x_mist-0.5 , x_mist-0.5; e_s2_avg-e_s2_std, e_s2_avg+e_s2_std].';

f = zeros(30,4);
for i = 1:30
    f(i,:) = [i,31+i,32+i,i+1];
end

%% Figure: over 2 - smoothed average/std by depth

% figure;
hold on

% Plot mean with error shading (grey)
patch('Faces',f,'Vertices', v_2S,'FaceColor',[216/255 191/255 216/255],'EdgeColor','none','FaceAlpha', 0.3)
patch('Faces',f,'Vertices', v_1S,'FaceColor',[221/255 160/255 221/255],'EdgeColor','none','FaceAlpha', 0.3)
plot(x_mist,e_s2_avg,'m','LineWidth',2)

% Plot bars for expected values based on macroDSC
patch('Faces',f_a,'Vertices', v_1,'FaceColor',[204/255 229/255 255/255],'EdgeColor','none','FaceAlpha', 0.5)
patch('Faces',f_a,'Vertices', v_2,'FaceColor',[153/255 204/255 255/255],'EdgeColor','none','FaceAlpha', 0.5)
patch('Faces',f_a,'Vertices', v_3,'FaceColor',[204/255 229/255 255/255],'EdgeColor','none','FaceAlpha', 0.5)
patch('Faces',f_a,'Vertices', v_4,'FaceColor',[153/255 204/255 255/255],'EdgeColor','none','FaceAlpha', 0.5)
plot([x_a x_b], [corr corr]-const, 'b-','LineWidth',1)
plot([x_b x_c], [Int_mean(1) Int_mean(1)]-const, 'b-','LineWidth',1)

% Plot raw data
plot(x_oc(remOLs_oc),enth_oc(remOLs_oc),'bo')
plot(x_ocrc(remOLs_ocrc),enth_ocrc(remOLs_ocrc),'bo')
plot(x_nc(remOLs_nc),enth_nc(remOLs_nc),'bo')
plot(x_ncrc(remOLs_ncrc),enth_ncrc(remOLs_ncrc),'bo')
plot(x_43(remOLs_43),enth_43(remOLs_43),'bo')
plot(x_44(remOLs_44),enth_44(remOLs_44),'bo')
plot(x_c4x(remOLs_c4x),enth_c4x(remOLs_c4x),'go')
plot(x_74(remOLs_74),enth_74(remOLs_74),'go')
plot(x_75(remOLs_75),enth_75(remOLs_75),'go')
plot(x_76(remOLs_76),enth_76(remOLs_76),'go')
plot(x_77(remOLs_77),enth_77(remOLs_77),'go')
plot(x_c3x(remOLs_c3x),enth_c3x(remOLs_c3x),'ro')
plot(x_78(remOLs_78),enth_78(remOLs_78),'ro')
plot(x_79(remOLs_79),enth_79(remOLs_79),'ko')
plot(x_80(remOLs_80),enth_80(remOLs_80),'mo')

xlabel('Slice Number ~ depth [\mum]')
ylabel('Recrystallizartion enthalpy [J/g]')
h = zeros(5, 1);
h(1) = plot(NaN,NaN,'bo');
h(2) = plot(NaN,NaN,'go');
h(3) = plot(NaN,NaN,'ro');
h(4) = plot(NaN,NaN,'ko');
h(5) = plot(NaN,NaN,'mo');

legend(h, 'set 5','set 4','set 3','set 2', 'set 1');

%% Figure to explain preinquiry summary

% % Guess based on Macro DSC, in MacroDSC colors
% load('coolAnalysis.mat')
% 
% x_a = 1;
% x_b = 20;
% x_c = 32;
% 
% % Correct for half-ish damage
% corr = (Int_mean(5)*50-Int_mean(1)*(50-x_b))/x_b;
% const = 7;
% 
% u_1 = corr-Int_mean(5)+Int_plus2S(5)-const;
% u_2 = corr-Int_mean(5)+Int_plus1S(5)-const;
% u_3 = corr-Int_mean(5)+Int_minus1S(5)-const;
% u_4 = corr-Int_mean(5)+Int_minus2S(5)-const;
% d_1 = Int_plus2S(1)-const;
% d_2 = Int_plus1S(1)-const;
% d_3 = Int_minus1S(1)-const;
% d_4 = Int_minus2S(1)-const;
% 
% v_1 = [x_a,u_4; x_a,u_1; x_b,u_1; x_b,u_4]; 
% v_2 = [x_a,u_3; x_a,u_2; x_b,u_2; x_b,u_3];
% v_3 = [x_b,d_4; x_b,d_1; x_c,d_1; x_c,d_4];
% v_4 = [x_b,d_3; x_b,d_2; x_c,d_2; x_c,d_3]; 
% 
% f_a = [1 2 3 4];
% 
% % Faces and vertices for mean and 2 stds of slice data
% 
% v_2S = [x_master , x_master; e_avg-2*e_std, e_avg+2*e_std].';
% v_1S = [x_master , x_master; e_avg-e_std, e_avg+e_std].';
% 
% f = zeros(31,4);
% for i = 1:31
%     f(i,:) = [i,32+i,33+i,i+1];
% end

figure;
hold on

% Plot mean with error shading (grey)
patch('Faces',f,'Vertices', v_2S,'FaceColor',[211/255 211/255 211/255],'EdgeColor','none','FaceAlpha', 0.3)
patch('Faces',f,'Vertices', v_1S,'FaceColor',[169/255 169/255 169/255],'EdgeColor','none','FaceAlpha', 0.3)
plot(x_master,e_avg,'k','LineWidth',2)

% Plot bars for expected values based on macroDSC
% patch('Faces',f_a,'Vertices', v_1,'FaceColor',[204/255 229/255 255/255],'EdgeColor','none','FaceAlpha', 0.5)
% patch('Faces',f_a,'Vertices', v_2,'FaceColor',[153/255 204/255 255/255],'EdgeColor','none','FaceAlpha', 0.5)
% patch('Faces',f_a,'Vertices', v_3,'FaceColor',[204/255 229/255 255/255],'EdgeColor','none','FaceAlpha', 0.5)
% patch('Faces',f_a,'Vertices', v_4,'FaceColor',[153/255 204/255 255/255],'EdgeColor','none','FaceAlpha', 0.5)
% plot([x_a x_b], [corr corr]-const, 'b-','LineWidth',1)
% plot([x_b x_c], [Int_mean(1) Int_mean(1)]-const, 'b-','LineWidth',1)

% Plot raw data
plot(x_oc(remOLs_oc),enth_oc(remOLs_oc),'ko')
plot(x_ocrc(remOLs_ocrc),enth_ocrc(remOLs_ocrc),'ko')
plot(x_nc(remOLs_nc),enth_nc(remOLs_nc),'ko')
plot(x_ncrc(remOLs_ncrc),enth_ncrc(remOLs_ncrc),'ko')
plot(x_43(remOLs_43),enth_43(remOLs_43),'ko')
plot(x_44(remOLs_44),enth_44(remOLs_44),'ko')
plot(x_c4x(remOLs_c4x),enth_c4x(remOLs_c4x),'ko')
plot(x_74(remOLs_74),enth_74(remOLs_74),'ko')
plot(x_75(remOLs_75),enth_75(remOLs_75),'ko')
plot(x_76(remOLs_76),enth_76(remOLs_76),'ko')
plot(x_77(remOLs_77),enth_77(remOLs_77),'ko')
plot(x_c3x(remOLs_c3x),enth_c3x(remOLs_c3x),'ko')
plot(x_78(remOLs_78),enth_78(remOLs_78),'ko')
plot(x_79(remOLs_79),enth_79(remOLs_79),'ko')
plot(x_80(remOLs_80),enth_80(remOLs_80),'ko')


h = zeros(3, 1);
h(1) = plot(NaN,NaN,'ko', 'LineWidth', 1);
h(2) = plot(NaN,NaN,'k-', 'LineWidth', 1);
h(3) = plot(NaN,NaN,'Color',[169/255 169/255 169/255], 'LineWidth', 1);
h(4) = plot(NaN,NaN,'Color',[211/255 211/255 211/255], 'LineWidth', 1);
legend(h, {'Individual data','2\mum mean','1\sigma', '2\sigma'},...
    'Location', 'southwest',...
    'Orientation','vertical',...
    'FontName','Helvetica',...
    'FontSize',12)

ax1 = gca; % Bottom horizontal axes
set(ax1,...
        'FontUnits','points',...
        'FontWeight','normal',...
        'FontSize',16,...
        'FontName','Helvetica',...
        'LineWidth',1.25,...
        'ylim',[2 42],...
        'xlim',[0 33],...
        'XColor', 'k',...
        'YColor', 'k',...
         'Box','on')
ylabel({'Recrystallization enthalpy [J/g]'},...
        'FontUnits','points',...
        'FontSize',20,...
        'FontName','Helvetica')
xlabel({'Slice Number ~ depth [\mum]'},...
        'FontUnits','points',...
        'FontSize',20,...
        'FontName','Helvetica')

























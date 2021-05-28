%% P-values to compare different enrichments

%% Cody's formatting block + color black

% figure;
% hold on
% set(gca,...
%         'FontUnits','points',...
%         'FontWeight','normal',...
%         'FontSize',16,...
%         'FontName','Helvetica',...
%         'LineWidth',1.25,...
%         'Box','on',...
%         'XGrid','on',...
%         'YGrid','on',...
%         'XColor','k',...
%         'YColor','k')
% ylabel({'Y Axis Label [units]'},...
%         'FontUnits','points',...
%         'FontSize',20,...
%         'FontName','Helvetica')
% xlabel({'X Axis Label [units]'},...
%         'FontUnits','points',...
%         'FontSize',20,...
%         'FontName','Helvetica')

%% Load workspaces - Choose data set.
load('coolData_processed.mat')
% adjust y axis for enthalpy not peak area --> divide by heating rate 
qdot = 10/60; % 10 degreesC/min in degC/s
Int_mean = Int_mean/qdot;
Int_std = Int_std/qdot;

%% Main result figure - Cooling

Int_plus1S = Int_mean+Int_std;
Int_minus1S = Int_mean-Int_std;
Int_plus2S = Int_mean+2*Int_std;
Int_minus2S = Int_mean-2*Int_std;
v1 = [coord, coord; Int_mean, Int_plus1S].';
v2 = [coord, coord; Int_mean, Int_minus1S].';
v3 = [coord, coord; Int_plus1S, Int_plus2S].';
v4 = [coord, coord; Int_minus1S, Int_minus2S].';
f = [1 6 7 2; 2 7 8 3; 3 8 9 4; 4 9 10 5];

figure('Name','Result');
hold on
patch('Faces',f,'Vertices', v1,'FaceColor',[153/255 204/255 255/255],'EdgeColor','none','FaceAlpha', 1)
patch('Faces',f,'Vertices', v2,'FaceColor',[153/255 204/255 255/255],'EdgeColor','none','FaceAlpha', 1)
patch('Faces',f,'Vertices', v3,'FaceColor',[204/255 229/255 255/255],'EdgeColor','none','FaceAlpha', 1)
patch('Faces',f,'Vertices', v4,'FaceColor',[204/255 229/255 255/255],'EdgeColor','none','FaceAlpha', 1)
plot(coord, Int_mean, 'ko-','LineWidth',2)

h = zeros(5, 1);
h(1) = plot(NaN,NaN,'ko-', 'LineWidth', 1);
h(2) = plot(NaN,NaN,'Color',[153/255 204/255 255/255], 'LineWidth', 1);
h(3) = plot(NaN,NaN,'Color',[204/255 229/255 255/255], 'LineWidth', 1);
h(4) = plot(NaN,NaN,'rp','MarkerSize',10,'MarkerFaceColor','r');
h(5) = plot(NaN,NaN,'r+','MarkerSize',10);
legend(h, {'Mean','1\sigma', '2\sigma','Extrapolated Mean','+ 1 standard deviation'},...
    'Location', 'northwest',...
    'FontName','Helvetica',...
    'FontSize',12)

% Second Axis
% For Nat., 5, 20, 90
enr = [0.72, 4.984, 20.14, 90.26]; %from my model
flu = [6.232e8 2.713e9 1.07e10 5.497e10]; %expected fluence
tic = log10(flu)-6;

ax1 = gca; % Bottom horizontal axes
set(ax1,...
        'FontUnits','points',...
        'FontWeight','normal',...
        'FontSize',16,...
        'FontName','Helvetica',...
        'LineWidth',1.25,...
        'XTick',[1 2 3 4 5],... % Make custom labels
        'XtickLabel',{'Ctrl', '10^{8}','10^{9}','10^{10}','10^{11}'},...
        'XLim', [0.75, 5.25],...
        'XColor', 'k',...
        'YColor', 'k')
ylabel({'Recrystallization Enthalpy [J/g]'},...
        'FontUnits','points',...
        'FontSize',20,...
        'FontName','Helvetica')
xlabel({'4.5 MeV \alpha Fluence [ions/cm^2]'},...
        'FontUnits','points',...
        'FontSize',20,...
        'FontName','Helvetica')
    
ax2 = axes('Position',ax1.Position,...
    'XAxisLocation','top',...
    'YAxisLocation','right',...
    'Color','none');
set(ax2,...
        'FontUnits','points',...
        'FontWeight','normal',...
        'FontSize',16,...
        'FontName','Helvetica',...
        'LineWidth',1.25,...
        'XTick',tic,... % Make custom labels
        'XtickLabel',{'Nat.', '5%','20%','90%'},...
        'XLim', [0.75, 5.25],...
        'YTick', [],...
        'YTickLabel', [],...
        'XColor', 'k',...
        'YColor', 'k');
xlabel({'Projected U-235 Enrichment in 1 year'},...
        'FontUnits','points',...
        'FontSize',20,...
        'FontName','Helvetica')
    
linkprop([ax1 ax2], {'Position', 'Units', 'ActivePositionProperty','PlotBoxAspectRatio'});
set(gca,'PlotBoxAspectRatio',[1 0.75 0.75])
set(gcf,'Position',[360 46 625 585]) %Make entire figure bigger

linkaxes([ax1 ax2], 'y')
ylim([17,30])

%% T-tests notes

% I've written two functions for basically reading off values from Figures
% 1 and 3 from the main paper which can then be used to calculate p-values:
% yearly flux = enrichment2flux([%])
% [mean, std] = fluence2Hcrys(yearly flux)

% Note 4-9-21: Based on discussion with mike/scott, will use a different
% fluence2Hcrys_poly2 to convert fluence to [mean,std], based on fit model.
% Also using enrichment2flux_model to directly calculate fluence

% I had been planning to do the built in ttest2 function, but because I am
% working with extrapolated means and standard deviations rather than the
% p-values for my actual data, I will hard code the calculation. Note that
% the sample numbers for this (20, 12, 12, 12, 12) are not such that a
% normal distribution can actually be assumed (I'm pretty sure), but oh well.

% To get the p-values:
% 1. Define sample numbers 
% 2. Choose enrichment values to caluculate at and comparisons to do
% 3. Calculate t statistic (two-sample t-test)
% 4. Calculate degrees of freedom
% 5. Use tcfd() to get p-values (H_a: m_x ~= m_y, two-tailed)

%% Sample numbers and data for comparison:

% 20 controls, 12 at each fluence: for comparison with any nonzero fluence
% extrapolated values, I will assume an n of 12.
n_un = 20;
n_nat = 12;
n_leu = 12;
n_heu = 12;
n_wgu = 12;

% Control (unirradiated)
[m_un,st_un] = fluence2Hcrys_poly2(0);

% Natural (0.72% U-235)
f_nat = enrichment2flux_model(0.72);
[m_nat,st_nat] = fluence2Hcrys_poly2(f_nat);

% LEU (5%)
f_leu = enrichment2flux_model(5);
[m_leu,st_leu] = fluence2Hcrys_poly2(f_leu);

% HEU (20%)
f_heu = enrichment2flux_model(20);
[m_heu,st_heu] = fluence2Hcrys_poly2(f_heu);

% Weapons grade (90%)
f_wgu = enrichment2flux_model(90);
[m_wgu,st_wgu] = fluence2Hcrys_poly2(f_wgu);

enr_combo = [0 0.72 5 20 90];
coord_combo = [1 (log10([f_nat f_leu f_heu f_wgu])-6)];
m_combo = [m_un m_nat m_leu m_heu m_wgu];
st_combo = [st_un st_nat st_leu st_heu st_wgu];

% Check values against data in plot:
hold on
plot(coord_combo, m_combo,'rp','MarkerSize',10,'MarkerFaceColor','r')
plot(coord_combo, m_combo+st_combo,'r+','MarkerSize',10)

%% Calculate t-statistic and DoF for two sample, unpaired, unequal variance

% Will compare for 10 scenarios:
% All four enrichments vs controls (4 p-values)
% Nat, LEU, HEU vs WgU (3 p-values)
% Nat, LEU vs HEU (2 p-values)
% Nat vs LEU (1 p-value)

% t statistic formula: (m_a-m_b)/sqrt(st_a^2/n_a+st_b^2/n_b)
% dof formula: (st_a^2/n_a+st_b^2/n_b)^2/(((st_a^2/n_a)^2/(n_a-1))+((st_b^2/n_b)^2/(n_b-1)))
% From https://www.statsdirect.co.uk/help/parametric_methods/utt.htm, but
% also confirmed that this is the same as the ttest2() built-in function uses.

% Made my own ttest2 function to spit out t_a_b and dof_a_b:

% Case 1-4: a = enriched(nat-Wg), b = unirradiated
[t_nat_un,dof_nat_un] = tstat_2sample(m_nat,st_nat,n_nat,m_un,st_un,n_un);
[t_leu_un,dof_leu_un] = tstat_2sample(m_leu,st_leu,n_leu,m_un,st_un,n_un);
[t_heu_un,dof_heu_un] = tstat_2sample(m_heu,st_heu,n_heu,m_un,st_un,n_un);
[t_wgu_un,dof_wgu_un] = tstat_2sample(m_wgu,st_wgu,n_wgu,m_un,st_un,n_un);

% Case 5-7: a = (nat, leu, heu), b = wgu
[t_nat_wgu,dof_nat_wgu] = tstat_2sample(m_nat,st_nat,n_nat,m_wgu,st_wgu,n_wgu);
[t_leu_wgu,dof_leu_wgu] = tstat_2sample(m_leu,st_leu,n_leu,m_wgu,st_wgu,n_wgu);
[t_heu_wgu,dof_heu_wgu] = tstat_2sample(m_heu,st_heu,n_heu,m_wgu,st_wgu,n_wgu);

% Case 8-9: a = (nat, leu), b = heu
[t_nat_heu,dof_nat_heu] = tstat_2sample(m_nat,st_nat,n_nat,m_heu,st_heu,n_heu);
[t_leu_heu,dof_leu_heu] = tstat_2sample(m_leu,st_leu,n_leu,m_heu,st_heu,n_heu);

% Case 10: a = nat, b = leu
[t_nat_leu,dof_nat_leu] = tstat_2sample(m_nat,st_nat,n_nat,m_leu,st_leu,n_leu);

%% Calculate p-values (two tail) given t and dof:
% Formula basically copied from ttest2()

p_nat_un = 2 * tcdf(-abs(t_nat_un),dof_nat_un);
p_leu_un = 2 * tcdf(-abs(t_leu_un),dof_leu_un);
p_heu_un = 2 * tcdf(-abs(t_heu_un),dof_heu_un);
p_wgu_un = 2 * tcdf(-abs(t_wgu_un),dof_wgu_un);
p_nat_wgu = 2 * tcdf(-abs(t_nat_wgu),dof_nat_wgu);
p_leu_wgu = 2 * tcdf(-abs(t_leu_wgu),dof_leu_wgu);
p_heu_wgu = 2 * tcdf(-abs(t_heu_wgu),dof_heu_wgu);
p_nat_heu = 2 * tcdf(-abs(t_nat_heu),dof_nat_heu);
p_leu_heu = 2 * tcdf(-abs(t_leu_heu),dof_leu_heu);
p_nat_leu = 2 * tcdf(-abs(t_nat_leu),dof_nat_leu);

%% Calculate p-values (two tail) given t and dof (conservative = 11):
% Formula basically copied from ttest2()
% check what happens when using a more conservative dof:
dofc_nat_un = 11;
dofc_leu_un = 11;
dofc_heu_un = 11;
dofc_wgu_un = 11;
dofc_nat_wgu = 11;
dofc_leu_wgu = 11;
dofc_heu_wgu = 11;
dofc_nat_heu = 11;
dofc_leu_heu = 11;
dofc_nat_leu = 11;

pc_nat_un = 2 * tcdf(-abs(t_nat_un),dofc_nat_un);
pc_leu_un = 2 * tcdf(-abs(t_leu_un),dofc_leu_un);
pc_heu_un = 2 * tcdf(-abs(t_heu_un),dofc_heu_un);
pc_wgu_un = 2 * tcdf(-abs(t_wgu_un),dofc_wgu_un);
pc_nat_wgu = 2 * tcdf(-abs(t_nat_wgu),dofc_nat_wgu);
pc_leu_wgu = 2 * tcdf(-abs(t_leu_wgu),dofc_leu_wgu);
pc_heu_wgu = 2 * tcdf(-abs(t_heu_wgu),dofc_heu_wgu);
pc_nat_heu = 2 * tcdf(-abs(t_nat_heu),dofc_nat_heu);
pc_leu_heu = 2 * tcdf(-abs(t_leu_heu),dofc_leu_heu);
pc_nat_leu = 2 * tcdf(-abs(t_nat_leu),dofc_nat_leu);

%% Disp all at once in order for table

p_combo = [p_nat_un;
    p_leu_un;
    p_heu_un
    p_wgu_un
    p_nat_wgu;
    p_leu_wgu;
    p_heu_wgu;
    p_nat_heu;
    p_leu_heu;
    p_nat_leu;];

pc_combo = [pc_nat_un;
    pc_leu_un;
    pc_heu_un
    pc_wgu_un
    pc_nat_wgu;
    pc_leu_wgu;
    pc_heu_wgu;
    pc_nat_heu;
    pc_leu_heu;
    pc_nat_leu;];

dof_combo = [dof_nat_un;
    dof_leu_un;
    dof_heu_un
    dof_wgu_un
    dof_nat_wgu;
    dof_leu_wgu;
    dof_heu_wgu;
    dof_nat_heu;
    dof_leu_heu;
    dof_nat_leu;];

t_combo = [t_nat_un;
    t_leu_un;
    t_heu_un
    t_wgu_un
    t_nat_wgu;
    t_leu_wgu;
    t_heu_wgu;
    t_nat_heu;
    t_leu_heu;
    t_nat_leu;];

m_s_combo = [m_un st_un;
    m_nat st_nat;
    m_leu st_leu;
    m_heu st_heu;
    m_wgu st_wgu;
    m_wgu st_wgu;
    m_nat st_nat;
    m_leu st_leu;
    m_heu st_heu;
    m_heu st_heu;
    m_nat st_nat;
    m_leu st_leu;
    m_leu st_leu;
    m_nat st_nat;];


















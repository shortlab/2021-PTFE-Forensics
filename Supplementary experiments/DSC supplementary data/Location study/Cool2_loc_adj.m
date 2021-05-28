function [T_int,Enthalpy] = Cool2_loc_adj()
% Cool2 all samples
% NOTE: index was short on Sample 5, hence modification in line 10.

% Control samples
% Editable filename...
path_main = 'C:\Users\Rachel\Documents\Rachel\MIT\MIT Research\Short Lab\';
path_specific = 'PTFE\Location Controlled Film\CSV\';
s1 = 'ptfe_position_control_sample';
s2 = '5';
s3 = '_cool2.csv';
sample = [s1 s2 s3];
file = [path_main path_specific sample];

SampleNum = 30;
[T, ~] = importDataCSV(file);
x = length(T);
T = zeros(length(T),SampleNum);
Q = T;

for i = 1:SampleNum
    c = num2str(i);
    sample = [s1 c s3];
    file = [path_main path_specific sample];
    [T_temp, Q_temp] = importDataCSV(file);
    T(:,i) = flip(T_temp(1:x));
    Q(:,i) = flip(Q_temp(1:x)); 
end

T_min = 260;  
T_max = 360; 
N = length(find(T(:,1) > T_min & T(:,1) < T_max));
T_int = zeros(N,SampleNum);
Q_int = T_int;
for i = 1:SampleNum
    run = [T(:,i), Q(:,i)];
    [T_temp, Q_temp] = Data_interp(run, T_min, T_max,N);
    T_int(:,i) = T_temp;
    Q_int(:,i) = Q_temp;
end


%%
% exportDSC('ptfe_flight2_controls_Temperature',T_int)
% exportDSC('ptfe_flight2_controls_HeatFlow',Q_int)

%% Check data
% figure;
% plot(T_int(:,1:30),Q_int(:,1:30),'b','LineWidth',1.5)
% title('Cooling 2nd run, interpolated')
% xlabel('Temperature [C]')
% ylabel('Heat Flow [J/g], exo up')

%% Baseline adjusted to match spline analysis in final analysis 

% 60 data points per degree
left_end = 20; % degrees from peak
right_end = 15; % degrees from peak
f = 2;

% Setup correct ranges

[~,index] = max(Q_int(:,1));
left = index - left_end*60;
right = index + right_end*60;
num = right-left+1;
mid_left = index - left_end*60/f;
mid_right = index + right_end*60/f;  
num_fit = (right-mid_right)+(mid_left-left)+2;

% Initialize holders for all correctly ranged data
T_peak = zeros(1,30);
T_corrected = zeros(num,30);
Q_temp = zeros(num,30);
T_fit = zeros(num_fit,30);
Q_fit = zeros(num_fit,30);
Q_baseline = zeros(num,30);
Q_corrected = zeros(num,30);

for j = 1:30
    % Find range
    [~,index] = max(Q_int(:,j));
    left = index - left_end*60;
    right = index + right_end*60;
    mid_left = index - left_end*60/f;
    mid_right = index + right_end*60/f;  
  
    % Save range and peak temperature
    Q_temp(:,j) = Q_int(left:right,j);
    T_corrected(:,j) = T_int(left:right,j);
    T_peak(j) = T_int(index,j);
    
    % Fit left and right straights to line
    T_right = T_int(mid_right:right,j);
    T_left = T_int(left:mid_left,j);
    T_fit(:,j) = [T_right; T_left];
    Q_right = Q_int(mid_right:right,j);
    Q_left = Q_int(left:mid_left,j);
    fit_right = [ones(length(T_right),1) T_right]\Q_right;
    fit_left = [ones(length(T_left),1) T_left]\Q_left;
    Q_fit(:,j) = [fit_right(1)+fit_right(2)*T_right; fit_left(1)+fit_left(2)*T_left];
    
    % Create spline
    Q_baseline(:,j) = spline(T_fit(:,j),Q_fit(:,j),T_corrected(:,j));
    
    % Subtract baseline from data
    Q_corrected(:,j) = Q_temp(:,j) - Q_baseline(:,j);    
end

%% Enthalpies
data = 30; 
Int = zeros(1,data);
for j = 1:data
    Int(j) = trapz(T_corrected(:,j),Q_corrected(:,j));
end

Enthalpy = Int/(10/60); % in correct units (normalized by heating rate)

%% Plot baseline corrected data:

c1 = [1 25 18 11 4];
c2 = [5 28 22 15 8];
c3 = [9 2 26 19 12];
c4 = [13 6 29 23 16];
c5 = [17 10 3 27 20];
c6 = [21 14 7 30 24];

figure;
hold on
for i = 1:length(c1)
    plot(T_corrected(:,c1(i)),Q_corrected(:,c1(i)),'b')
    plot(T_corrected(:,c2(i)),Q_corrected(:,c2(i)),'g')
    plot(T_corrected(:,c3(i)),Q_corrected(:,c3(i)),'k')
    plot(T_corrected(:,c4(i)),Q_corrected(:,c4(i)),'y')
    plot(T_corrected(:,c5(i)),Q_corrected(:,c5(i)),'r')
    plot(T_corrected(:,c6(i)),Q_corrected(:,c6(i)),'m')
end
title('Recrystallization peaks colored by column')


h = zeros(6, 1);
h(1) = plot(NaN,NaN,'b');
h(2) = plot(NaN,NaN,'g');
h(3) = plot(NaN,NaN,'k');
h(4) = plot(NaN,NaN,'y');
h(5) = plot(NaN,NaN,'r');
h(6) = plot(NaN,NaN,'m');

legend(h, 'Column 1','Column 2','Column 3','Column 4','Column 5','Column 6',...
    'Location', 'northwest');
set(gca,...
        'FontUnits','points',...
        'FontWeight','normal',...
        'FontSize',16,...
        'FontName','Helvetica',...
        'LineWidth',1.25,...
        'Box','on',...
        'XLim', [305 320],...
        'Ylim', [-0.1 1.55],...
        'XColor','k',...
        'YColor','k')
ylabel({'Heat Flow [W/g], exo up'},...
        'FontUnits','points',...
        'FontSize',20,...
        'FontName','Helvetica')
xlabel({'Temperature [^{\circ}C]'},...
        'FontUnits','points',...
        'FontSize',20,...
        'FontName','Helvetica')


end





    
    
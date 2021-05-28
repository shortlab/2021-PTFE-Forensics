function [T_int,Enthalpy] = Heat2_loc_adj()
% Heat2 all samples

% Control samples
% Editable filename...
path_main = 'C:\Users\Rachel\Documents\Rachel\MIT\MIT Research\Short Lab\';
path_specific = 'PTFE\Location Controlled Film\CSV\';
s1 = 'ptfe_position_control_sample';
s2 = '1';
s3 = '_heat2.csv';
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
    T(:,i) = T_temp(1:x);
    Q(:,i) = Q_temp(1:x); 
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
% title('Heating 2nd run, interpolated')
% xlabel('Temperature [C]')
% ylabel('Heat Flow [J/g], exo up')

%% Baseline adjusted to match spline analysis in final analysis 

% 60 data points per degree
left_end = 30; % degrees from peak
right_end = 15; % degrees from peak
f = 2;

% Setup correct ranges

[~,index] = min(Q_int(:,1));
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
    [~,index] = min(Q_int(:,j));
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

Enthalpy = Int/(10/60);

end






    
    
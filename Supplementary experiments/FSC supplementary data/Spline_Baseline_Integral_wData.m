function [ints,T_corr,Q_corr] = Spline_Baseline_Integral_wData(T,Q,x)
% For integrating Flash DSC PTFE cooling data (from run3). 
% Inputs: T,Q,x imported/loaded data in [C,mW,slice number]
% Outputs: the integrals for each sample based on spline baselines.
% Assumptions: Peaks are within [250,360] without hook contribution (don't 
% actually need to trim for spline however). The construction lines for the 
% splines are fit from [220,260] to [350,365]. 


%% Correctly orient data (assuming cooling)
Q = flipud(Q);
T = flipud(T);
n = length(x);

%% Spline baseline

ints = zeros(1,n);

% straight construction segments
T_ll = 220;
T_lr = 260;
T_rl = 350;
T_rr = 365;
Q_corr = zeros(1450,15);
T_corr = zeros(1450,15);
for i = 1:n
    T_current = T(:,i);
    Q_current = Q(:,i);
    
    % Get correct indexes and data ranges
    left = find(T_current > T_ll & T_current < T_lr);
    right = find(T_current > T_rl & T_current < T_rr);
    corrected = find(T_current > T_ll & T_current < T_rr);
    T_left = T_current(left);
    T_right = T_current(right);
    Q_left = Q_current(left);
    Q_right = Q_current(right);
    T_corrected = T_current(corrected);
    Q_temp = Q_current(corrected);
    
    % Fit left and right straights to line
    T_fit = [T_right; T_left];
    fit_right = [ones(length(T_right),1) T_right]\Q_right;
    fit_left = [ones(length(T_left),1) T_left]\Q_left;
    Q_fit = [fit_right(1)+fit_right(2)*T_right; fit_left(1)+fit_left(2)*T_left];
    
    % Create spline
    Q_spline = spline(T_fit,Q_fit,T_corrected);
    disp(i)
    disp(length(Q_temp))
    Q_corr(:,i) = Q_temp - Q_spline; 
    T_corr(:,i) = T_corrected;
    ints(i) = trapz(T_corrected,Q_corr(:,i));
       
end

end


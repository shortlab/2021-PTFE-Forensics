function [T_int,Q_shifted] = Heat2_s2()
% Heat2 all samples

% Control samples
% Editable filename...
path_main = 'C:\Users\Rachel\Documents\Rachel\MIT\MIT Research\Short Lab\';
path_specific = 'PTFE\He irradiated set2\CSV\';
s1 = 'ptfe_he_set2_c_';
s2 = '1';
s3 = '_heat2.csv';
sample = [s1 s2 s3];
file = [path_main path_specific sample];

SampleNum = 6;
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


% 1e10 samples
% Editable filename...
s1 = 'ptfe_he_set2_10_';
SampleNum = 6;

for i = 1:SampleNum
    c = num2str(i);
    sample = [s1 c s3];
    file = [path_main path_specific sample];
    [T_temp, Q_temp] = importDataCSV(file);
    T(:,i) = T_temp(1:x);
    Q(:,i) = Q_temp(1:x); 
end

for i = 1:SampleNum
    run = [T(:,i), Q(:,i)];
    [T_temp, Q_temp] = Data_interp(run, T_min, T_max,N);
    T_int(:,i+6) = T_temp;
    Q_int(:,i+6) = Q_temp;
end


% 1e11 samples
% Editable filename...
s1 = 'ptfe_he_set2_11_';
SampleNum = 6;

for i = 1:SampleNum
    c = num2str(i);
    sample = [s1 c s3];
    file = [path_main path_specific sample];
    [T_temp, Q_temp] = importDataCSV(file);
    T(:,i) = T_temp(1:x);
    Q(:,i) = Q_temp(1:x); 
end

for i = 1:SampleNum
    run = [T(:,i), Q(:,i)];
    [T_temp, Q_temp] = Data_interp(run, T_min, T_max,N);
    T_int(:,i+12) = T_temp;
    Q_int(:,i+12) = Q_temp;
end

% 1e12 samples
% Editable filename...
s1 = 'ptfe_he_set2_12_';
SampleNum = 6;

for i = 1:SampleNum
    c = num2str(i);
    sample = [s1 c s3];
    file = [path_main path_specific sample];
    [T_temp, Q_temp] = importDataCSV(file);
    T(:,i) = T_temp(1:x);
    Q(:,i) = Q_temp(1:x); 
end

for i = 1:SampleNum
    run = [T(:,i), Q(:,i)];
    [T_temp, Q_temp] = Data_interp(run, T_min, T_max,N);
    T_int(:,i+18) = T_temp;
    Q_int(:,i+18) = Q_temp;
end


%%
% exportDSC('ptfe_flight2_controls_Temperature',T_int)
% exportDSC('ptfe_flight2_controls_HeatFlow',Q_int)

%% Check data
% figure;
% plot(T_int(:,1:6),Q_int(:,1:6),'b','LineWidth',1.5)
% hold on
% plot(T_int(:,7:12),Q_int(:,7:12),'r','LineWidth',1.5)
% plot(T_int(:,13:18),Q_int(:,13:18),'g','LineWidth',1.5)
% plot(T_int(:,19:24),Q_int(:,19:24),'k','LineWidth',1.5)
% title('Heating 2nd run, interpolated')
% xlabel('Temperature [C]')
% ylabel('Heat Flow [J/g], exo up')

%%
% Q_shifted = Q_int_control - Q_int_control(1,:);    
shift = (Q_int(N,:) - Q_int(1,:))/(T_max-T_min).*...
    (T_int-T_min)+Q_int(1,:);    

Q_shifted = Q_int - shift;

% figure;
% plot(T_int(:,1:6),Q_shifted(:,1:6),'b','LineWidth',1.5)
% hold on
% plot(T_int(:,7:12),Q_shifted(:,7:12),'r','LineWidth',1.5)
% plot(T_int(:,13:18),Q_shifted(:,13:18),'g','LineWidth',1.5)
% plot(T_int(:,19:24),Q_shifted(:,19:24),'k','LineWidth',1.5)
% title('Heating 2nd run, de-hooked')
% xlabel('Temperature [C]')
% ylabel('Heat Flow [J/g], exo up')

end






    
    
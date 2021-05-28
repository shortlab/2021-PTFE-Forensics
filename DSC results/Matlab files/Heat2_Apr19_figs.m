%% Heat2_Apr19_figs - Creation of baseline comparison figures
% Includes straight baseline, spline baseline connecting linear sections,
% Peak area analysis figures using both methods

%% Load data
% Control samples
% Editable filename...
path_main = 'C:\Users\Rachel\Documents\Rachel\MIT\MIT Research\Short Lab\';
path_specific = 'PTFE\Irradiated April 2019\CSV\';
s1 = 'ptfe_postirr_ctrl_';
s2 = '1';
s3 = '_heat2.csv';
sample = [s1 s2 s3];
file = [path_main path_specific sample];

SampleNum = 20;
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


% 1e08 samples
% Editable filename...
s1 = 'ptfe_postirr_1e08_';
SampleNum = 12;

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
    T_int(:,i+20) = T_temp;
    Q_int(:,i+20) = Q_temp;
end


% 1e09 samples
% Editable filename...
s1 = 'ptfe_postirr_1e09_';
SampleNum = 12;

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
    T_int(:,i+32) = T_temp;
    Q_int(:,i+32) = Q_temp;
end

% 1e10 samples
% Editable filename...
s1 = 'ptfe_postirr_1e10_';
SampleNum = 12;

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
    T_int(:,i+44) = T_temp;
    Q_int(:,i+44) = Q_temp;
end

% 1e11 samples
% Editable filename...
s1 = 'ptfe_postirr_1e11_';
SampleNum = 12;

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
    T_int(:,i+56) = T_temp;
    Q_int(:,i+56) = Q_temp;
end

%% Linear baseline: Output: T_int, Q_shifted

shift = (Q_int(N,:) - Q_int(1,:))/(T_max-T_min).*...
    (T_int-T_min)+Q_int(1,:);    
Q_shifted = Q_int - shift;

figure;
hold on
plot(T_int(:,2),Q_int(:,2),'b','LineWidth',1)
% plot(T_int(:,2),shift(:,2),'b--','LineWidth',1)
title('Example of Linear Baseline')
xlabel('Temperature [C]')
ylabel('Heat Flow [W/g], exo up')
h = zeros(2, 1);
h(1) = plot(NaN,NaN,'b', 'LineWidth', 1);
h(2) = plot(NaN,NaN,'b--', 'LineWidth', 1);
legend(h, 'Raw Data','Linear Baseline');

figure;
hold on
plot(T_int(:,57:68),Q_shifted(:,57:68),'m','LineWidth',1)
plot(T_int(:,45:56),Q_shifted(:,45:56),'k','LineWidth',1)
plot(T_int(:,1:20),Q_shifted(:,1:20),'b','LineWidth',1)
plot(T_int(:,33:44),Q_shifted(:,33:44),'g','LineWidth',1)
plot(T_int(:,21:32),Q_shifted(:,21:32),'r','LineWidth',1)

title('Heating 2nd run, linear baseline')
xlabel('Temperature [C]')
ylabel('Heat Flow [W/g], exo up')
h = zeros(5, 1);
h(1) = plot(NaN,NaN,'b', 'LineWidth', 1);
h(2) = plot(NaN,NaN,'r', 'LineWidth', 1);
h(3) = plot(NaN,NaN,'g', 'LineWidth', 1);
h(4) = plot(NaN,NaN,'k', 'LineWidth', 1);
h(5) = plot(NaN,NaN,'m', 'LineWidth', 1);
legend(h, 'Unirradiated','10^{8} ions/cm^2','10^{9} ions/cm^2','10^{10} ions/cm^2','10^{11} ions/cm^2');

%% Spline Baseline: Output: T_PP_all, Q_PP_all

mn = 295;
mx = 355;
upper = 340;
lower = 310;

for j = 1:20
    T_lg = T_int(:,j);
    T = T_lg(T_lg<mx & T_lg>mn);
    Q_lg = Q_int(:,j);
    Q = Q_lg(T_lg<mx & T_lg>mn);
    Q_r = Q(T>upper);
    T_r = T(T>upper); 
    Q_l = Q(T<lower);
    T_l = T(T<lower);
    sr = [ones(length(T_r),1) T_r]\Q_r;
    Q_sr = sr(1)+ T*sr(2);
    sl = [ones(length(T_l),1) T_l]\Q_l;
    Q_sl = sl(1)+ T*sl(2);
    Q_1 = Q-Q_sl; 
    Q_2 = Q-Q_sr;
    Q_b = [sl(1)+ T_l*sl(2); sr(1)+ T_r*sr(2)];
    T_b = [T_l; T_r];
    PP = spline(T_b,Q_b,T);
    Q_PP = Q-PP;
    Q_PP_all(:,j) = Q_PP;
    T_PP_all(:,j) = T;
    if j == 2
        figure;
        hold on
        plot(T_lg,Q_lg,'b','LineWidth',1)
        plot(T,PP,'b--','LineWidth',1)
        title('Example of Spline Baseline')
        xlabel('Temperature [C]')
        ylabel('Heat Flow [W/g], exo up')
        h = zeros(2, 1);
        h(1) = plot(NaN,NaN,'b', 'LineWidth', 1);
        h(2) = plot(NaN,NaN,'b--', 'LineWidth', 1);
        legend(h, 'Raw Data','Spline Baseline');
    end
end

for j = 21:32
    T_lg = T_int(:,j);
    T = T_lg(T_lg<mx & T_lg>mn);
    Q_lg = Q_int(:,j);
    Q = Q_lg(T_lg<mx & T_lg>mn);
    Q_r = Q(T>upper);
    T_r = T(T>upper); 
    Q_l = Q(T<lower);
    T_l = T(T<lower);
    sr = [ones(length(T_r),1) T_r]\Q_r;
    Q_sr = sr(1)+ T*sr(2);
    sl = [ones(length(T_l),1) T_l]\Q_l;
    Q_sl = sl(1)+ T*sl(2);
    Q_1 = Q-Q_sl; 
    Q_2 = Q-Q_sr;
    Q_b = [sl(1)+ T_l*sl(2); sr(1)+ T_r*sr(2)];
    T_b = [T_l; T_r];
    PP = spline(T_b,Q_b,T);
    Q_PP = Q-PP;
    Q_PP_all(:,j) = Q_PP;
    T_PP_all(:,j) = T;
end

for j = 33:44
    T_lg = T_int(:,j);
    T = T_lg(T_lg<mx & T_lg>mn);
    Q_lg = Q_int(:,j);
    Q = Q_lg(T_lg<mx & T_lg>mn);
    Q_r = Q(T>upper);
    T_r = T(T>upper); 
    Q_l = Q(T<lower);
    T_l = T(T<lower);
    sr = [ones(length(T_r),1) T_r]\Q_r;
    Q_sr = sr(1)+ T*sr(2);
    sl = [ones(length(T_l),1) T_l]\Q_l;
    Q_sl = sl(1)+ T*sl(2);
    Q_1 = Q-Q_sl; 
    Q_2 = Q-Q_sr;
    Q_b = [sl(1)+ T_l*sl(2); sr(1)+ T_r*sr(2)];
    T_b = [T_l; T_r];
    PP = spline(T_b,Q_b,T);
    Q_PP = Q-PP;
    Q_PP_all(:,j) = Q_PP;
    T_PP_all(:,j) = T;
end

for j = 45:56
    T_lg = T_int(:,j);
    T = T_lg(T_lg<mx & T_lg>mn);
    Q_lg = Q_int(:,j);
    Q = Q_lg(T_lg<mx & T_lg>mn);
    Q_r = Q(T>upper);
    T_r = T(T>upper); 
    Q_l = Q(T<lower);
    T_l = T(T<lower);
    sr = [ones(length(T_r),1) T_r]\Q_r;
    Q_sr = sr(1)+ T*sr(2);
    sl = [ones(length(T_l),1) T_l]\Q_l;
    Q_sl = sl(1)+ T*sl(2);
    Q_1 = Q-Q_sl; 
    Q_2 = Q-Q_sr;
    Q_b = [sl(1)+ T_l*sl(2); sr(1)+ T_r*sr(2)];
    T_b = [T_l; T_r];
    PP = spline(T_b,Q_b,T);
    Q_PP = Q-PP;
    Q_PP_all(:,j) = Q_PP;
    T_PP_all(:,j) = T;
end

for j = 57:68
    T_lg = T_int(:,j);
    T = T_lg(T_lg<mx & T_lg>mn);
    Q_lg = Q_int(:,j);
    Q = Q_lg(T_lg<mx & T_lg>mn);
    Q_r = Q(T>upper);
    T_r = T(T>upper); 
    Q_l = Q(T<lower);
    T_l = T(T<lower);
    sr = [ones(length(T_r),1) T_r]\Q_r;
    Q_sr = sr(1)+ T*sr(2);
    sl = [ones(length(T_l),1) T_l]\Q_l;
    Q_sl = sl(1)+ T*sl(2);
    Q_1 = Q-Q_sl; 
    Q_2 = Q-Q_sr;
    Q_b = [sl(1)+ T_l*sl(2); sr(1)+ T_r*sr(2)];
    T_b = [T_l; T_r];
    PP = spline(T_b,Q_b,T);
    Q_PP = Q-PP;
    Q_PP_all(:,j) = Q_PP;
    T_PP_all(:,j) = T;
end

figure;
hold on
plot(T_PP_all(:,57:68),Q_PP_all(:,57:68),'m','LineWidth',1)
plot(T_PP_all(:,45:56),Q_PP_all(:,45:56),'k','LineWidth',1)
plot(T_PP_all(:,1:20),Q_PP_all(:,1:20),'b','LineWidth',1)
plot(T_PP_all(:,33:44),Q_PP_all(:,33:44),'g','LineWidth',1)
plot(T_PP_all(:,21:32),Q_PP_all(:,21:32),'r','LineWidth',1)

title('Heating 2nd run, spline baseline')
xlabel('Temperature [C]')
ylabel('Heat Flow [W/g], exo up')
h = zeros(5, 1);
h(1) = plot(NaN,NaN,'b', 'LineWidth', 1);
h(2) = plot(NaN,NaN,'r', 'LineWidth', 1);
h(3) = plot(NaN,NaN,'g', 'LineWidth', 1);
h(4) = plot(NaN,NaN,'k', 'LineWidth', 1);
h(5) = plot(NaN,NaN,'m', 'LineWidth', 1);
legend(h, 'Unirradiated','10^{8} ions/cm^2','10^{9} ions/cm^2','10^{10} ions/cm^2','10^{11} ions/cm^2');

%% Linear baseline integrals

n = 295; % miNimum
x = 355; % maXimum
data = 68; 
Int_linear = zeros(1,data);
for i = 1:data % 20 control samples
    ind = find(T_int(:,i) > n & T_int(:,i) < x);
    T_Heat2_s(:,i) = T_int(ind,i);
    Q_Heat2_s(:,i) = Q_shifted(ind,i);
end 
for j = 1:data
Int_linear(j) = trapz(T_Heat2_s(:,j),Q_Heat2_s(:,j));
end

% Mean:
Int_mean_linear = zeros(1,5);
Int_mean_linear(1) = mean(Int_linear(1:20));
Int_mean_linear(2) = mean(Int_linear(21:32));
Int_mean_linear(3) = mean(Int_linear(33:44));
Int_mean_linear(4) = mean(Int_linear(45:56));
Int_mean_linear(5) = mean(Int_linear(57:68));

% Std:
Int_std_linear = zeros(1,5);
Int_std_linear(1) = std(Int_linear(1:20));
Int_std_linear(2) = std(Int_linear(21:32));
Int_std_linear(3) = std(Int_linear(33:44));
Int_std_linear(4) = std(Int_linear(45:56));
Int_std_linear(5) = std(Int_linear(57:68));

coord = [1 2 3 4 5];
figure;
errorbar(coord, Int_mean_linear, Int_std_linear,'o-','LineWidth',1)
title('Linear Baseline')
xlabel('Fluence [ions/cm^2]')
xticks([1 2 3 4 5]);
xticklabels({'Ctrl', '10^{8}','10^{9}','10^{10}','10^{11}'});
xlim([0.75, 5.25])
ax = gca;
c = ax.FontSize;
ax.FontSize =10;
ylabel('Peak Area [W/g ^{\circ}C]')

%% Spline baseline integrals

data = 68; 
Int_spline = zeros(1,data);
for j = 1:data
    Int_spline(j) = trapz(T_PP_all(:,j),Q_PP_all(:,j));
end

% Mean:
Int_mean_spline = zeros(1,5);
Int_mean_spline(1) = mean(Int_spline(1:20));
Int_mean_spline(2) = mean(Int_spline(21:32));
Int_mean_spline(3) = mean(Int_spline(33:44));
Int_mean_spline(4) = mean(Int_spline(45:56));
Int_mean_spline(5) = mean(Int_spline(57:68));

% Std:
Int_std_spline = zeros(1,5);
Int_std_spline(1) = std(Int_spline(1:20));
Int_std_spline(2) = std(Int_spline(21:32));
Int_std_spline(3) = std(Int_spline(33:44));
Int_std_spline(4) = std(Int_spline(45:56));
Int_std_spline(5) = std(Int_spline(57:68));

coord = [1 2 3 4 5];
figure;
errorbar(coord, Int_mean_spline, Int_std_spline,'o-','LineWidth',1)
title('Spline Baseline')
xlabel('Fluence [ions/cm^2]')
xticks([1 2 3 4 5]);
xticklabels({'Ctrl', '10^{8}','10^{9}','10^{10}','10^{11}'});
xlim([0.75, 5.25])
ax = gca;
c = ax.FontSize;
ax.FontSize =10;
ylabel('Peak Area [W/g ^{\circ}C]')

%% Linear: Check peak locations and heights

data = 68;
Peak_linear = zeros(1,data);
High_linear = zeros(1,data);
for i = 1:data
    [~,ind] = min(Q_shifted(:,i));
    Peak_linear(i) = T_int(ind,i);
    High_linear(i) = Q_shifted(ind,i);
end

% Mean:
Peak_mean_linear = zeros(1,5);
Peak_mean_linear(1) = mean(Peak_linear(1:20));
Peak_mean_linear(2) = mean(Peak_linear(21:32));
Peak_mean_linear(3) = mean(Peak_linear(33:44));
Peak_mean_linear(4) = mean(Peak_linear(45:56));
Peak_mean_linear(5) = mean(Peak_linear(57:68));

% Std:
Peak_std_linear = zeros(1,5);
Peak_std_linear(1) = std(Peak_linear(1:20));
Peak_std_linear(2) = std(Peak_linear(21:32));
Peak_std_linear(3) = std(Peak_linear(33:44));
Peak_std_linear(4) = std(Peak_linear(45:56));
Peak_std_linear(5) = std(Peak_linear(57:68));

% Mean:
High_mean_linear = zeros(1,5);
High_mean_linear(1) = mean(High_linear(1:20));
High_mean_linear(2) = mean(High_linear(21:32));
High_mean_linear(3) = mean(High_linear(33:44));
High_mean_linear(4) = mean(High_linear(45:56));
High_mean_linear(5) = mean(High_linear(57:68));

% Std:
High_std_linear = zeros(1,5);
High_std_linear(1) = std(High_linear(1:20));
High_std_linear(2) = std(High_linear(21:32));
High_std_linear(3) = std(High_linear(33:44));
High_std_linear(4) = std(High_linear(45:56));
High_std_linear(5) = std(High_linear(57:68));

coord = [1 2 3 4 5];
figure;
errorbar(coord, Peak_mean_linear, Peak_std_linear,'o-','LineWidth',1)
title('Linear Baseline')
xlabel('Fluence [ions/cm^2]')
xticks([1 2 3 4 5]);
xticklabels({'Ctrl', '10^{8}','10^{9}','10^{10}','10^{11}'});
xlim([0.75, 5.25])
ax = gca;
c = ax.FontSize;
ax.FontSize =10;
ylabel('Peak Temperature [^{\circ}C]')
figure;
errorbar(coord, High_mean_linear, High_std_linear,'o-','LineWidth',1)

%% Spline: Check peak locations and heights

data = 68;
Peak_spline = zeros(1,data);
High_spline = zeros(1,data);
for i = 1:data
    [~,ind] = min(Q_PP_all(:,i));
    Peak_spline(i) = T_PP_all(ind,i);
    High_spline(i) = Q_PP_all(ind,i);
end

% Mean:
Peak_mean_spline = zeros(1,5);
Peak_mean_spline(1) = mean(Peak_spline(1:20));
Peak_mean_spline(2) = mean(Peak_spline(21:32));
Peak_mean_spline(3) = mean(Peak_spline(33:44));
Peak_mean_spline(4) = mean(Peak_spline(45:56));
Peak_mean_spline(5) = mean(Peak_spline(57:68));

% Std:
Peak_std_spline = zeros(1,5);
Peak_std_spline(1) = std(Peak_spline(1:20));
Peak_std_spline(2) = std(Peak_spline(21:32));
Peak_std_spline(3) = std(Peak_spline(33:44));
Peak_std_spline(4) = std(Peak_spline(45:56));
Peak_std_spline(5) = std(Peak_spline(57:68));

% Mean:
High_mean_spline = zeros(1,5);
High_mean_spline(1) = mean(High_spline(1:20));
High_mean_spline(2) = mean(High_spline(21:32));
High_mean_spline(3) = mean(High_spline(33:44));
High_mean_spline(4) = mean(High_spline(45:56));
High_mean_spline(5) = mean(High_spline(57:68));

% Std:
High_std_spline = zeros(1,5);
High_std_spline(1) = std(High_spline(1:20));
High_std_spline(2) = std(High_spline(21:32));
High_std_spline(3) = std(High_spline(33:44));
High_std_spline(4) = std(High_spline(45:56));
High_std_spline(5) = std(High_spline(57:68));

coord = [1 2 3 4 5];
figure;
errorbar(coord, Peak_mean_spline, Peak_std_spline,'o-','LineWidth',1)
title('Spline Baseline')
xlabel('Fluence [ions/cm^2]')
xticks([1 2 3 4 5]);
xticklabels({'Ctrl', '10^{8}','10^{9}','10^{10}','10^{11}'});
xlim([0.75, 5.25])
ax = gca;
c = ax.FontSize;
ax.FontSize =10;
ylabel('Peak Temperature [^{\circ}C]')
figure;
errorbar(coord, High_mean_spline, High_std_spline,'o-','LineWidth',1)

%% Sample coordinates

x_coord = [6,17,3,17,3,7,12,9,12,13,8,7,16,19,7,2,21,2,20,6,3,20,20,...
    8,15,8,18,5,18,13,13,10,4,19,19,9,14,9,4,19,4,14,9,14,5,18,5,18,...
    5,10,20,8,15,15,13,13,2,21,2,21,16,7,17,17,12,11,12,16];
y_coord = [1,2,3,4,5,1,2,3,4,1,2,4,5,1,6,6,5,4,3,2,1,2,4,1,2,3,3,2,...
    1,5,3,2,1,2,4,1,4,5,4,3,2,3,2,1,1,2,3,4,5,1,1,4,3,1,4,2,1,2,3,4,...
    2,3,3,1,3,2,1,4];

x_ctrl = [6,17,3,17,3,7,12,9,12,13,8,7,16,19,7,2,21,2,20,6];
y_ctrl = [1,2,3,4,5,1,2,3,4,1,2,4,5,1,6,6,5,4,3,2];
Int_ctrl_linear = Int_linear(1:20);
Int_ctrl_spline = Int_spline(1:20);
Peak_ctrl_linear = Peak_linear(1:20);
Peak_ctrl_spline = Peak_spline(1:20);
High_ctrl_linear = High_linear(1:20);
High_ctrl_spline = High_spline(1:20);
% I think the spline is more manageable 

%% Check location labels

% Box number coordinating with DSC samples 1:20;1:12;1:12;1:12;1:12
boxNum = [1; 5; 9; 13; 17; 2; 6; 10; 14; 3; 7; 15; 19; 4; 23; 24; 20;
16; 12; 8; 1; 5; 13; 2; 6; 10; 12; 8; 4; 19; 11; 7; 1; 5; 13; 2; 14;
18; 16; 12; 8; 11; 7; 3; 1; 5; 9; 13; 17; 2; 4; 15; 11; 3; 14; 6; 1; 5;
9; 13; 6; 10; 12; 4; 11; 7; 3; 14];

s_label = {'1','5','9','13','17','2','6','10','14','3','7','15','19','4','23','24','20','16','12','8'};
figure;
hold on
plot(x_ctrl,y_ctrl,'o')
text(x_ctrl,y_ctrl,s_label)


%% Check shape of control peak area surface

figure;
plot(x_ctrl,Int_ctrl_spline,'o')
text(x_ctrl,Int_ctrl_spline,s_label)
title('Int vs x')

figure;
plot(y_ctrl,Int_ctrl_spline,'o')
text(y_ctrl,Int_ctrl_spline,s_label)
title('Int vs y')




% figure;
% plot(x_ctrl,Peak_ctrl_spline,'o')
% title('Peak vs x')
% 
% figure;
% plot(y_ctrl,Peak_ctrl_spline,'o')
% title('Peak vs y')

%% Check out ratio of peak area to height/location - unhelpful

PA_loc = Int_spline./Peak_spline;
PA_high = Int_spline./High_spline;
PA_high_loc = Int_spline./Peak_spline./High_spline;

coord_long = [ones(1,20) ones(1,12)*2 ones(1,12)*3 ones(1,12)*4 ones(1,12)*5];
figure;
plot(coord_long, PA_loc, 'o')
figure;
plot(coord_long, PA_high, 'o')
figure;
plot(coord_long, Int_spline, 'o')
figure;
plot(coord_long, Peak_spline, 'o')
figure
plot(coord_long, High_spline, 'o')
figure;
plot(coord_long, PA_high_loc,'o')

%% Peak area control surface: x - 2nd degree; y - 1st degree
% Result from cftool
% Linear model Poly21:
%      f(x,y) = p00 + p10*x + p01*y + p20*x^2 + p11*x*y
% Coefficients (with 95% confidence bounds):
%        p00 =      -2.602  (-2.834, -2.369)
%        p10 =    -0.03254  (-0.06554, 0.0004611)
%        p01 =    -0.05992  (-0.1033, -0.01654)
%        p20 =    0.001035  (-0.0001714, 0.00224)
%        p11 =    0.001939  (-0.001692, 0.00557)
% Goodness of fit:
%   SSE: 0.07598
%   R-square: 0.5103
%   Adjusted R-square: 0.3798
%   RMSE: 0.07117
p00 = -2.602; 
p10 = -0.03254; 
p01 = -0.05992;  
p20 = 0.001035;  
p11 = 0.001939;  
Int_corr_poly = zeros(1,48);
coord_long = [ones(1,12)*2 ones(1,12)*3 ones(1,12)*4 ones(1,12)*5];
for i = 21:68
    Int_corr_poly(i-20) = Int_spline(i) - (p00 + p10*x_coord(i) +...
        p01*y_coord(i) + p20*x_coord(i)^2 + p11*x_coord(i)*y_coord(i));
end

figure;
plot(coord_long,Int_corr_poly,'o')

% Mean:
Int_mean_corr_poly = zeros(1,4);
Int_mean_corr_poly(1) = mean(Int_corr_poly(1:12));
Int_mean_corr_poly(2) = mean(Int_corr_poly(13:24));
Int_mean_corr_poly(3) = mean(Int_corr_poly(25:36));
Int_mean_corr_poly(4) = mean(Int_corr_poly(37:48));

% Std:
Int_std_corr_poly = zeros(1,4);
Int_std_corr_poly(1) = std(Int_corr_poly(1:12));
Int_std_corr_poly(2) = std(Int_corr_poly(13:24));
Int_std_corr_poly(3) = std(Int_corr_poly(25:36));
Int_std_corr_poly(4) = std(Int_corr_poly(37:48));

coord = [1 2 3 4];
figure;
errorbar(coord, Int_mean_corr_poly, Int_std_corr_poly,'o-','LineWidth',1)

%% Peak area control surface: interpolant
% Result from cftool saved as createFit_Int(x,y,z)

Int_corr_interp = zeros(1,48);
[fitresult,~] = createFit_Int(x_ctrl,y_ctrl,Int_ctrl_spline);
coord_long = [ones(1,12)*2 ones(1,12)*3 ones(1,12)*4 ones(1,12)*5];
for i = 21:68
    Int_corr_interp(i-20) = Int_spline(i) - fitresult(x_coord(i),y_coord(i));
end

figure;
plot(coord_long,Int_corr_interp,'o')

% Mean:
Int_mean_corr_interp = zeros(1,4);
Int_mean_corr_interp(1) = mean(rmmissing(Int_corr_interp(1:12)));
Int_mean_corr_interp(2) = mean(rmmissing(Int_corr_interp(13:24)));
Int_mean_corr_interp(3) = mean(rmmissing(Int_corr_interp(25:36)));
Int_mean_corr_interp(4) = mean(rmmissing(Int_corr_interp(37:48)));

% Std:
Int_std_corr_interp = zeros(1,4);
Int_std_corr_interp(1) = std(rmmissing(Int_corr_interp(1:12)));
Int_std_corr_interp(2) = std(rmmissing(Int_corr_interp(13:24)));
Int_std_corr_interp(3) = std(rmmissing(Int_corr_interp(25:36)));
Int_std_corr_interp(4) = std(rmmissing(Int_corr_interp(37:48)));

coord_mid = [2 3 4 5];
figure;
errorbar(coord_mid, Int_mean_corr_interp, Int_std_corr_interp,'o-','LineWidth',1)

%% Compare stds (relative to measurement)

coord = [1 2 3 4 5];

figure;
hold on
plot(coord, -Int_std_linear./Int_mean_linear,'bo-')
plot(coord, -Int_std_spline./Int_mean_spline,'ro-')
% plot(coord_mid, -Int_std_corr_interp./Int_mean_corr_interp,'go-')
% plot(coord_mid, -Int_std_corr_poly./Int_mean_corr_poly,'ko-')
title('Peak Area Relative Deviation')
legend('Linear','Spline')
ylabel('1-SD normalized by Peak Area')
xlabel('Fluence [ions/cm^2]')
xticks([1 2 3 4 5]);
xticklabels({'Ctrl', '10^{8}','10^{9}','10^{10}','10^{11}'});
xlim([0.75, 5.25])
set(gca,...
        'FontUnits','points',...
        'FontWeight','normal',...
        'FontSize',10,...
        'FontName','Helvetica')


figure;
hold on
plot(coord, Peak_std_linear./Peak_mean_linear,'bo-')
plot(coord, Peak_std_spline./Peak_mean_spline,'ro-')
title('Peak Location Relative Deviation')
legend('Linear','Spline')
xlabel('Fluence [ions/cm^2]')
xticks([1 2 3 4 5]);
xticklabels({'Ctrl', '10^{8}','10^{9}','10^{10}','10^{11}'});
xlim([0.75, 5.25])
ax = gca;
c = ax.FontSize;
ax.FontSize =10;

figure;
hold on
plot(coord, -High_std_linear./High_mean_linear,'bo-')
plot(coord, -High_std_spline./High_mean_spline,'ro-')
title('Peak Height Relative Deviation')
legend('Linear','Spline')

%% Spline: Check peak heights and FWHMs

data = 68;
FWHM_spline = zeros(1,data);
Hght_spline = zeros(1,data);
for i = 1:data
    [~,ind] = min(Q_PP_all(:,i)); % Peak index
    peak_T = T_PP_all(ind,i); % Peak temperature
    Hght_spline(i) = Q_PP_all(ind,i);
    HM = Q_PP_all(ind,i)/2;
    T_FWHM = T(Q_PP_all(:,i)<=HM);
    FWHM_spline(i) = 2*(T_FWHM(end)-peak_T);
end

% Mean:
FWHM_mean_spline = zeros(1,5);
FWHM_mean_spline(1) = mean(FWHM_spline(1:20));
FWHM_mean_spline(2) = mean(FWHM_spline(21:32));
FWHM_mean_spline(3) = mean(FWHM_spline(33:44));
FWHM_mean_spline(4) = mean(FWHM_spline(45:56));
FWHM_mean_spline(5) = mean(FWHM_spline(57:68));

% Std:
FWHM_std_spline = zeros(1,5);
FWHM_std_spline(1) = std(FWHM_spline(1:20));
FWHM_std_spline(2) = std(FWHM_spline(21:32));
FWHM_std_spline(3) = std(FWHM_spline(33:44));
FWHM_std_spline(4) = std(FWHM_spline(45:56));
FWHM_std_spline(5) = std(FWHM_spline(57:68));

% Mean:
Hght_mean_spline = zeros(1,5);
Hght_mean_spline(1) = mean(Hght_spline(1:20));
Hght_mean_spline(2) = mean(Hght_spline(21:32));
Hght_mean_spline(3) = mean(Hght_spline(33:44));
Hght_mean_spline(4) = mean(Hght_spline(45:56));
Hght_mean_spline(5) = mean(Hght_spline(57:68));

% Std:
Hght_std_spline = zeros(1,5);
Hght_std_spline(1) = std(Hght_spline(1:20));
Hght_std_spline(2) = std(Hght_spline(21:32));
Hght_std_spline(3) = std(Hght_spline(33:44));
Hght_std_spline(4) = std(Hght_spline(45:56));
Hght_std_spline(5) = std(Hght_spline(57:68));

coord = [1 2 3 4 5];
figure;
errorbar(coord, FWHM_mean_spline, FWHM_std_spline,'o-','LineWidth',1)
title('Mean FWHM vs fluence')
xlabel('Fluence [ions/cm^2]')
xticks([1 2 3 4 5]);
xticklabels({'Ctrl', '10^{8}','10^{9}','10^{10}','10^{11}'});
xlim([0.75, 5.25])
ax = gca;
c = ax.FontSize;
ax.FontSize =10;
ylabel('FWHM [^{\circ}C]')

figure;
errorbar(coord, Hght_mean_spline, Hght_std_spline,'o-','LineWidth',1)
title('Mean peak height vs fluence')
xlabel('Fluence [ions/cm^2]')
xticks([1 2 3 4 5]);
xticklabels({'Ctrl', '10^{8}','10^{9}','10^{10}','10^{11}'});
xlim([0.75, 5.25])
ax = gca;
c = ax.FontSize;
ax.FontSize =10;
ylabel('Peak Height [W/g]')

%% Ratio of Peak Height to FWHM

% Mean
r_mean_spline = zeros(1,5);
r_mean_spline(1) = -mean(Hght_spline(1:20)./FWHM_spline(1:20));
r_mean_spline(2) = -mean(Hght_spline(21:32)./FWHM_spline(21:32));
r_mean_spline(3) = -mean(Hght_spline(33:44)./FWHM_spline(33:44));
r_mean_spline(4) = -mean(Hght_spline(45:56)./FWHM_spline(45:56));
r_mean_spline(5) = -mean(Hght_spline(57:68)./FWHM_spline(57:68));

% Std:
r_std_spline = zeros(1,5);
r_std_spline(1) = std(Hght_spline(1:20)./FWHM_spline(1:20));
r_std_spline(2) = std(Hght_spline(21:32)./FWHM_spline(21:32));
r_std_spline(3) = std(Hght_spline(33:44)./FWHM_spline(33:44));
r_std_spline(4) = std(Hght_spline(45:56)./FWHM_spline(45:56));
r_std_spline(5) = std(Hght_spline(57:68)./FWHM_spline(57:68));

figure;
errorbar(coord, r_mean_spline, r_std_spline,'o-','LineWidth',1)
title('Mean peak height/FWHM vs fluence')
xlabel('Fluence [ions/cm^2]')
xticks([1 2 3 4 5]);
xticklabels({'Ctrl', '10^{8}','10^{9}','10^{10}','10^{11}'});
xlim([0.75, 5.25])
ax = gca;
c = ax.FontSize;
ax.FontSize =10;
ylabel('Absolute Ratio [W/g^{\circ}C]')
















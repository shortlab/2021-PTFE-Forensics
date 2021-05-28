%% Heating rate data analysis

%% Load Data:

load('HR_rawData.mat')



%% Interpolate to same data lengths

temp = T_3352_cool(:,1);
T_range = linspace(temp(1),temp(end),3350);

Q_heat = zeros(3350,15);
T_heat = zeros(3350,15);
Q_cool = zeros(3350,15);
T_cool = zeros(3350,15);
qdot = [qdot_3352 qdot_6702 qdot_16752];

for i = 1:5
    T_heat(:,i) = T_range;
    T_cool(:,i) = T_range;
    Q_heat(:,i) = interp1(T_3352_heat(:,i),Q_3352_heat(:,i),T_range); 
    Q_cool(:,i) = interp1(T_3352_cool(:,i),Q_3352_cool(:,i),T_range);    
end
for i = 1:8
    T_heat(:,i+5) = T_range;
    T_cool(:,i+5) = T_range;
    Q_heat(:,i+5) = interp1(T_6702_heat(:,i),Q_6702_heat(:,i),T_range); 
    Q_cool(:,i+5) = interp1(T_6702_cool(:,i),Q_6702_cool(:,i),T_range);    
end
for i = 1:2
    T_heat(:,i+13) = T_range;
    T_cool(:,i+13) = T_range;
    Q_heat(:,i+13) = interp1(T_16752_heat(:,i),Q_16752_heat(:,i),T_range); 
    Q_cool(:,i+13) = interp1(T_16752_cool(:,i),Q_16752_cool(:,i),T_range);    
end

%% Visualize data normalized by heating rate

figure;
hold on
for i = 1:15
    plot(T_cool(:,i),Q_cool(:,i)/qdot(i));
end

%% Take spline baselines before normalizing

[ints,T_corr,Q_corr] = Spline_Baseline_Integral_wData(T_cool,Q_cool,qdot);

figure;
hold on
plot(T_corr(:,5),Q_corr(:,5),'b')
plot(T_corr(:,3:4),Q_corr(:,3:4),'r')
plot(T_corr(:,8:9),Q_corr(:,8:9),'c')
plot(T_corr(:,1:2),Q_corr(:,1:2),'m')
plot(T_corr(:,14:15),Q_corr(:,14:15),'k')
plot(T_corr(:,6:7),Q_corr(:,6:7),'g')
plot(T_corr(:,10:13),Q_corr(:,10:13),'g')
xlabel('Temperature [^{\circ}C]')
ylabel('Heat Flow [mW]')
title('Various cooling rates (spline baseline subtracted)')
h = zeros(6, 1);
h(1) = plot(NaN,NaN,'b');
h(2) = plot(NaN,NaN,'r');
h(3) = plot(NaN,NaN,'c');
h(4) = plot(NaN,NaN,'m');
h(5) = plot(NaN,NaN,'k');
h(6) = plot(NaN,NaN,'g');
legend(h, {'1 K/s','10 K/s','50 K/s','100 K/s','200 K/s', '500 K/s'})



figure;
hold on
for i = 1:15
    plot(T_corr(:,i),Q_corr(:,i)/qdot(i));
end

%% Check qdot-normalized 

enth = ints./qdot;
figure;
hold on
plot(qdot,enth,'o');





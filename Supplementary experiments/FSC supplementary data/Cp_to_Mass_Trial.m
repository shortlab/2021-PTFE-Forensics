%% Mass check based on cp for Class5, on chip 53044
% Following methods outlined in Schick's Fast scanning calorimetry book

% From what I can tell, it needs to be compared to other data (see lit),
% but I don't really need to do the whole range. So I will just look from
% about 80-200 C?

% Techincal note: should probably actually do cool3 + heat4, but oh well
% for now.

%% Load heating and cooling data (round 3)....

load('formattedData_again.mat')
Q_44h = Q_44_heat3;
T_44h = T_44_heat3;
Q_44c = flipud(Q_44_cool3);
T_44c = flipud(T_44_cool3);

%% Check plot

figure;
hold on
% plot(T_44h,Q_44h,'b-')
% plot(T_44c,Q_44c,'r-')
plot(T_44h(:,15),Q_44h(:,15),'r','Linewidth',2)
plot(T_44c(:,15),Q_44c(:,15),'b','Linewidth',2)
ylim([-0.25,0.2])
xlabel('Temperature [^{\circ}C]')
ylabel('Heat Flow [mW]')

%% Trim to desired range
% Between Tmin=250 and Tmax=345
Tmin = 80;
Tmax = 200;

for i = 1:length(x_44)
    ind = find(T_44c(:,i) > Tmin & T_44c(:,i) < Tmax);
    T_44c_trim(:,i) = T_44c(ind,i);
    Q_44c_trim(:,i) = Q_44c(ind,i);
    ind = find(T_44h(:,i) > Tmin & T_44h(:,i) < Tmax);
    T_44h_trim(:,i) = T_44h(ind,i);
    Q_44h_trim(:,i) = Q_44h(ind,i);
end

%% Check trimmed plot

figure;
hold on
plot(T_44h_trim(:,15),Q_44h_trim(:,15),'b-')
plot(T_44c_trim(:,15),Q_44c_trim(:,15),'r-')

%% Fit straight lines and average for symmetry line

for i = 1:length(x_44)
    fit_cool = [ones(length(T_44c_trim(:,i)),1) T_44c_trim(:,i)]\Q_44c_trim(:,i);
    fit_heat = [ones(length(T_44h_trim(:,i)),1) T_44h_trim(:,i)]\Q_44h_trim(:,i);
    m_sym(i) = (fit_cool(2)+fit_heat(2))/2;
    b_sym(i) = (fit_cool(1)+fit_heat(1))/2;
    Q_44c_fit(:,i) = fit_cool(1)+fit_cool(2)*T_44c_trim(:,i);
    Q_44h_fit(:,i) = fit_heat(1)+fit_heat(2)*T_44h_trim(:,i);
    ex_sym(:,i) = b_sym(i) + m_sym(i)*T_44c_trim(:,i);
    % and now adjust by subtracting symmetry line from cool and heat
    Q_44c_adj(:,i) = Q_44c_trim(:,i) - (b_sym(i) + m_sym(i)*T_44c_trim(:,i));
    Q_44h_adj(:,i) = Q_44h_trim(:,i) - (b_sym(i) + m_sym(i)*T_44h_trim(:,i));
end

%% Check fit lines plot

figure;
hold on
plot(T_44h_trim,Q_44h_trim,'b-')
plot(T_44c_trim,Q_44c_trim,'r-')
plot(T_44h_trim,Q_44h_fit,'g-')
plot(T_44c_trim,Q_44c_fit,'m-')
% example of symmetry lines
plot(T_44h_trim,ex_sym,'k-')

% Show adjusted figures
figure;
hold on
% plot(T_44h_trim,Q_44h_trim,'b-')
% plot(T_44c_trim,Q_44c_trim,'r-')
plot(T_44h_trim,Q_44h_adj,'g-')
plot(T_44c_trim,Q_44c_adj,'m-')

%% Correct with heating rate +/- 500 Kps
% Q [mW] / rate [K/s] = [mJ/degC]

heat = -500;
cool = 500;

for i = 1:length(x_44)
    cp_44c(:,i) = (Q_44c_trim(:,i) - (b_sym(i) + m_sym(i)*T_44c_trim(:,i)))/cool;
    cp_44h(:,i) = (Q_44h_trim(:,i) - (b_sym(i) + m_sym(i)*T_44h_trim(:,i)))/heat;
end

figure;
hold on
% plot(T_44h_trim,Q_44h_trim,'b-')
% plot(T_44c_trim,Q_44c_trim,'r-')
plot(T_44h_trim,cp_44h,'g*')
plot(T_44c_trim,cp_44c,'m-')

%% Data on cp from literature
% (Wunderlich, 1970) - Heat capacities of linear high polymers, pp. 331-335

T_K = [360; 370; 380; 390; 400; 425; 450];
Cp_caldegmol = [12.25; 12.4; 12.6; 12.7; 12.9; 13.4; 13.8];

figure;
plot(T_K,Cp_caldegmol,'ko-')

% convert to T [deg C], Cp specific [mJ/C/mg]
T_lit = T_K-273.15;
Cp_lit = Cp_caldegmol*4.184/50;

figure;
plot(T_lit,Cp_lit,'ko-')

%% Compare data for realsies

% My data is currently in units of [mJ/degC]
% If I take at multiple temperatures myData/litData, that should give me mg
% Note: myData will be the average of the (potentiall interpolated) heat/cool values

for i = 1:length(x_44)
    for j = 1:length(T_lit)
        cp_c = interp1(T_44c_trim(:,i),cp_44c(:,i),T_lit(j));
        cp_h = interp1(T_44h_trim(:,i),cp_44h(:,i),T_lit(j));
        cp_avg(j,i) = (cp_c + cp_h)/2; 
    end   
    mass(:,i) = cp_avg(:,i)./Cp_lit;
end

figure;
hold on
plot(T_44h_trim,cp_44h,'g*')
plot(T_44c_trim,cp_44c,'m-')
plot(T_lit, cp_avg,'k*')

%% Plot calculated mass vs. temperature: expect flat lines near 100 ng
% And... not too shabby! (remember order of magnitude of ng vs mg dummy)

% convert mg to ng
mass_ng = mass*1e6;

figure;
plot(T_lit,mass_ng,'ko-')

%% Average mass values for single mass per sample

for i = 1:length(x_44)
    mass_44(i) = mean(mass_ng(:,i));
end

mass_44_plot = [mass_44; mass_44];
T_plot = [T_lit(1); T_lit(end)];

figure;
hold on
plot(T_lit,mass_ng,'k*-')
plot(T_plot,mass_44_plot,'Color', [150 150 150]/255,'LineWidth',2)
xlabel('Temperature [C]')
ylabel('Mass [ng]')

h = zeros(2, 1);
h(1) = plot(NaN,NaN,'k*-');
h(2) = plot(NaN,NaN,'Color', [150 150 150]/255, 'LineWidth', 2);

legend(h,'Mass by C_p method','Averaged mass')

%% Great! success? compare to hooks from old data:
% Awesome... Does not explain away discrepancies between measurements of
% the same samples, but that's fine. It will do for now, and it is at least
% a method that is rooted in literature.

% To Do: redo with cool3 -> heat4 + All the other data as well because why
% not. 

h_44 = [0.0918508159923566,0.0813740917503082,0.112897874205731,0.101942995363059,0.123993680146854,0.0981641596185902,0.111666008209380,0.112283932297424,0.114994477531996,0.0785622888702306,0.114231114455995,0.110069005562519,0.100335186132070,0.128847962750916,0.100076511288443,0.109910827315329,0.138205439408895,0.165951343896445,0.143527484453643,0.100485680865783,0.110449234952095,0.132953254328055];

figure;
plot(mass_44,h_44,'ko')


%% Explanatory Figure

figure;
hold on
plot(T_44h_trim(:,15),Q_44h_trim(:,15),'r-','LineWidth',2)
plot(T_44c_trim(:,15),Q_44c_trim(:,15),'b-','LineWidth',2)
plot(T_44h_trim(:,15),ex_sym(:,10),'k-','LineWidth',2)
plot(T_44h_trim(:,15),Q_44h_adj(:,15),'r--','LineWidth',2)
plot(T_44c_trim(:,15),Q_44c_adj(:,15),'b--','LineWidth',2)

title('Mass estimation method from Cp')
xlabel('Temperature [^{\circ}C]')
ylabel('Heat Flow [mW]')

h = zeros(4, 1);
h(1) = plot(NaN,NaN,'b-','LineWidth',2);
h(2) = plot(NaN,NaN,'r-','LineWidth',2);
h(3) = plot(NaN,NaN,'k-','LineWidth',2);
h(4) = plot(NaN,NaN,'--','Color', [150 150 150]/255,'LineWidth',2);
legend(h, 'Heating Data','Cooling Data','Symmetry Line','Adjusted Data');










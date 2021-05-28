% Script producing plots of rerun data
% All data interpolated and de-hooked

%% Heat1
[T_Heat1,Q_Heat1] = Heat1_s2();

% figure;
% plot(T_Heat1(:,1:6),Q_Heat1(:,1:6),'b','LineWidth',1.5)
% hold on
% plot(T_Heat1(:,7:12),Q_Heat1(:,7:12),'r','LineWidth',1.5)
% plot(T_Heat1(:,13:18),Q_Heat1(:,13:18),'g','LineWidth',1.5)
% plot(T_Heat1(:,19:24),Q_Heat1(:,19:24),'k','LineWidth',1.5)
% title('Heating 1st run, de-hooked')
% xlabel('Temperature [C]')
% ylabel('Heat Flow [J/g], exo up')


%% Heat2
[T_Heat2,Q_Heat2] = Heat2_s2();

% figure;
% plot(T_Heat2(:,1:6),Q_Heat2(:,1:6),'b','LineWidth',1.5)
% hold on
% plot(T_Heat2(:,7:12),Q_Heat2(:,7:12),'r','LineWidth',1.5)
% plot(T_Heat2(:,13:18),Q_Heat2(:,13:18),'g','LineWidth',1.5)
% plot(T_Heat2(:,19:24),Q_Heat2(:,19:24),'k','LineWidth',1.5)
% title('Heating 2nd run, de-hooked')
% xlabel('Temperature [C]')
% ylabel('Heat Flow [J/g], exo up')


%% Heat3
[T_Heat3,Q_Heat3] = Heat3_s2();

% figure;
% plot(T_Heat3(:,1:6),Q_Heat3(:,1:6),'b','LineWidth',1.5)
% hold on
% plot(T_Heat3(:,7:12),Q_Heat3(:,7:12),'r','LineWidth',1.5)
% plot(T_Heat3(:,13:18),Q_Heat3(:,13:18),'g','LineWidth',1.5)
% plot(T_Heat3(:,19:24),Q_Heat3(:,19:24),'k','LineWidth',1.5)
% title('Heating 3rd run, de-hooked')
% xlabel('Temperature [C]')
% ylabel('Heat Flow [J/g], exo up')



%% Cool1
[T_Cool1,Q_Cool1] = Cool1_s2();

% figure;
% plot(T_Cool1(:,1:6),Q_Cool1(:,1:6),'b','LineWidth',1.5)
% hold on
% plot(T_Cool1(:,7:12),Q_Cool1(:,7:12),'r','LineWidth',1.5)
% plot(T_Cool1(:,13:18),Q_Cool1(:,13:18),'g','LineWidth',1.5)
% plot(T_Cool1(:,19:24),Q_Cool1(:,19:24),'k','LineWidth',1.5)
% title('Cooling 1st run, de-hooked')
% xlabel('Temperature [C]')
% ylabel('Heat Flow [J/g], exo up')




%% Cool2
[T_Cool2,Q_Cool2] = Cool2_s2();

% figure;
% plot(T_Cool2(:,1:6),Q_Cool2(:,1:6),'b','LineWidth',1.5)
% hold on
% plot(T_Cool2(:,7:12),Q_Cool2(:,7:12),'r','LineWidth',1.5)
% plot(T_Cool2(:,13:18),Q_Cool2(:,13:18),'g','LineWidth',1.5)
% plot(T_Cool2(:,19:24),Q_Cool2(:,19:24),'k','LineWidth',1.5)
% title('Cooling 2nd run, de-hooked')
% xlabel('Temperature [C]')
% ylabel('Heat Flow [J/g], exo up')


%% Cool3
[T_Cool3,Q_Cool3] = Cool3_s2();

% figure;
% plot(T_Cool3(:,1:6),Q_Cool3(:,1:6),'b','LineWidth',1.5)
% hold on
% plot(T_Cool3(:,7:12),Q_Cool3(:,7:12),'r','LineWidth',1.5)
% plot(T_Cool3(:,13:18),Q_Cool3(:,13:18),'g','LineWidth',1.5)
% plot(T_Cool3(:,19:24),Q_Cool3(:,19:24),'k','LineWidth',1.5)
% title('Cooling 3rd run, de-hooked')
% xlabel('Temperature [C]')
% ylabel('Heat Flow [J/g], exo up')

%% Heat composite plot

% figure;
% hold on
% 
% plot(T_Heat2(:,1:6),Q_Heat2(:,1:6),'b-','LineWidth',1.5)
% plot(T_Heat2(:,7:12),Q_Heat2(:,7:12),'r-','LineWidth',1.5)
% plot(T_Heat2(:,13:18),Q_Heat2(:,13:18),'g-','LineWidth',1.5)
% plot(T_Heat2(:,19:24),Q_Heat2(:,19:24),'k-','LineWidth',1.5)
% plot(T_Heat3(:,1:6),Q_Heat3(:,1:6),'b--','LineWidth',1.5)
% plot(T_Heat3(:,7:12),Q_Heat3(:,7:12),'r--','LineWidth',1.5)
% plot(T_Heat3(:,13:18),Q_Heat3(:,13:18),'g--','LineWidth',1.5)
% plot(T_Heat3(:,19:24),Q_Heat3(:,19:24),'k--','LineWidth',1.5)
% 
% title('Heating 2nd and 3rd runs, hook corrected')
% xlabel('Temperature [C]')
% ylabel('Heat Flow [J/g], exo up')

%% Cool composite plot

% figure;
% hold on
% 
% plot(T_Cool2(:,1:6),Q_Cool2(:,1:6),'b-','LineWidth',1.5)
% plot(T_Cool2(:,7:12),Q_Cool2(:,7:12),'r-','LineWidth',1.5)
% plot(T_Cool2(:,13:18),Q_Cool2(:,13:18),'g-','LineWidth',1.5)
% plot(T_Cool2(:,19:24),Q_Cool2(:,19:24),'k-','LineWidth',1.5)
% plot(T_Cool3(:,1:6),Q_Cool3(:,1:6),'b--','LineWidth',1.5)
% plot(T_Cool3(:,7:12),Q_Cool3(:,7:12),'r--','LineWidth',1.5)
% plot(T_Cool3(:,13:18),Q_Cool3(:,13:18),'g--','LineWidth',1.5)
% plot(T_Cool3(:,19:24),Q_Cool3(:,19:24),'k--','LineWidth',1.5)
% 
% title('Cooling 2nd and 3rd runs, hook corrected')
% xlabel('Temperature [C]')
% ylabel('Heat Flow [J/g], exo up')

% All composite plot

figure;
hold on

plot(T_Heat2(:,1:6),Q_Heat2(:,1:6),'b-','LineWidth',1.5)
plot(T_Heat2(:,7:12),Q_Heat2(:,7:12),'r-','LineWidth',1.5)
plot(T_Heat2(:,13:18),Q_Heat2(:,13:18),'g-','LineWidth',1.5)
plot(T_Heat2(:,19:24),Q_Heat2(:,19:24),'k-','LineWidth',1.5)
plot(T_Heat3(:,1:6),Q_Heat3(:,1:6),'b--','LineWidth',1.5)
plot(T_Heat3(:,7:12),Q_Heat3(:,7:12),'r--','LineWidth',1.5)
plot(T_Heat3(:,13:18),Q_Heat3(:,13:18),'g--','LineWidth',1.5)
plot(T_Heat3(:,19:24),Q_Heat3(:,19:24),'k--','LineWidth',1.5)
plot(T_Cool2(:,1:6),Q_Cool2(:,1:6),'b-','LineWidth',1.5)
plot(T_Cool2(:,7:12),Q_Cool2(:,7:12),'r-','LineWidth',1.5)
plot(T_Cool2(:,13:18),Q_Cool2(:,13:18),'g-','LineWidth',1.5)
plot(T_Cool2(:,19:24),Q_Cool2(:,19:24),'k-','LineWidth',1.5)
plot(T_Cool3(:,1:6),Q_Cool3(:,1:6),'b--','LineWidth',1.5)
plot(T_Cool3(:,7:12),Q_Cool3(:,7:12),'r--','LineWidth',1.5)
plot(T_Cool3(:,13:18),Q_Cool3(:,13:18),'g--','LineWidth',1.5)
plot(T_Cool3(:,19:24),Q_Cool3(:,19:24),'k--','LineWidth',1.5)

title('2nd (solid) and 3rd (dashed) runs, hook corrected')
xlabel('Temperature [C]')
ylabel('Heat Flow [J/g], exo up')

h = zeros(4, 1);
h(1) = plot(NaN,NaN,'b', 'LineWidth', 1.5);
h(2) = plot(NaN,NaN,'r', 'LineWidth', 1.5);
h(3) = plot(NaN,NaN,'g', 'LineWidth', 1.5);
h(4) = plot(NaN,NaN,'k', 'LineWidth', 1.5);
legend(h, 'Unirradiated','10^{10} ions/cm^2','10^{11} ions/cm^2','10^{12} ions/cm^2');

set(gca,...
        'FontUnits','points',...
        'FontWeight','normal',...
        'FontSize',16,...
        'FontName','Helvetica',...
        'LineWidth',1.25,...
        'Box','on',...
        'XLim', [305 335],...
        'Ylim', [-2 1.5],...
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
title('2nd (solid) and 3rd (dashed) runs, with baseline subtracted')


%% Colors
% plot(x,y,'-','Color', [r/255 g/255 b/255])
% Blue - [0/255 0/255 255/255]
% Mid Blue - [70/255 130/255 180/255]
% Light Blue - [0/255 191/255 255/255]
% Green - [0/255 100/255 0/255]
% Mid Green - [50/255 205/255 50/255]
% Light Green - [127/255 255/255 0/255]
% Red - [165/255 42/255 42/255]
% Mid Red - [255/255 0/255 0/255]
% Light Red - [240/255 128/255 128/255]
% Purple - [148/255 0/255 211/255]
% Mid Purple - [147/255 112/255 219/255]
% Light Purple - [186/255 85/255 211/255]

%% Total composite plot

T_Heat2_s2 = T_Heat2;
Q_Heat2_s2 = Q_Heat2;
T_Heat3_s2 = T_Heat3;
Q_Heat3_s2 = Q_Heat3;
T_Cool2_s2 = T_Cool2;
Q_Cool2_s2 = Q_Cool2;
T_Cool3_s2 = T_Cool3;
Q_Cool3_s2 = Q_Cool3;

figure;
hold on

plot(T_Heat2_s2(:,1:6),Q_Heat2_s2(:,1:6),'-','LineWidth',1.5,'Color',[0/255 0/255 255/255])
plot(T_Heat2_s2(:,7:12),Q_Heat2_s2(:,7:12),'-','LineWidth',1.5,'Color',[0/255 100/255 0/255])
plot(T_Heat2_s2(:,13:18),Q_Heat2_s2(:,13:18),'-','LineWidth',1.5,'Color',[165/255 42/255 42/255])
plot(T_Heat2_s2(:,19:24),Q_Heat2_s2(:,19:24),'-','LineWidth',1.5,'Color',[148/255 0/255 211/255])
plot(T_Heat3_s2(:,1:6),Q_Heat3_s2(:,1:6),'--','LineWidth',1.5,'Color',[0/255 0/255 255/255])
plot(T_Heat3_s2(:,7:12),Q_Heat3_s2(:,7:12),'--','LineWidth',1.5,'Color',[0/255 100/255 0/255])
plot(T_Heat3_s2(:,13:18),Q_Heat3_s2(:,13:18),'--','LineWidth',1.5,'Color',[165/255 42/255 42/255])
plot(T_Heat3_s2(:,19:24),Q_Heat3_s2(:,19:24),'--','LineWidth',1.5,'Color',[148/255 0/255 211/255])
plot(T_Cool2_s2(:,1:6),Q_Cool2_s2(:,1:6),'-','LineWidth',1.5,'Color',[0/255 0/255 255/255])
plot(T_Cool2_s2(:,7:12),Q_Cool2_s2(:,7:12),'-','LineWidth',1.5,'Color',[0/255 100/255 0/255])
plot(T_Cool2_s2(:,13:18),Q_Cool2_s2(:,13:18),'-','LineWidth',1.5,'Color',[165/255 42/255 42/255])
plot(T_Cool2_s2(:,19:24),Q_Cool2_s2(:,19:24),'-','LineWidth',1.5,'Color',[148/255 0/255 211/255])
plot(T_Cool3_s2(:,1:6),Q_Cool3_s2(:,1:6),'--','LineWidth',1.5,'Color',[0/255 0/255 255/255])
plot(T_Cool3_s2(:,7:12),Q_Cool3_s2(:,7:12),'--','LineWidth',1.5,'Color',[0/255 100/255 0/255])
plot(T_Cool3_s2(:,13:18),Q_Cool3_s2(:,13:18),'--','LineWidth',1.5,'Color',[165/255 42/255 42/255])
plot(T_Cool3_s2(:,19:24),Q_Cool3_s2(:,19:24),'--','LineWidth',1.5,'Color',[148/255 0/255 211/255])

title('2nd (solid) and 3rd (dashed) runs, hook corrected')
xlabel('Temperature [C]')
ylabel('Heat Flow [J/g], exo up')

h = zeros(4, 1);
h(1) = plot(NaN,NaN,'Color',[0/255 0/255 255/255] , 'LineWidth', 1.5);
h(2) = plot(NaN,NaN,'Color',[0/255 100/255 0/255] , 'LineWidth', 1.5);
h(3) = plot(NaN,NaN,'Color',[165/255 42/255 42/255] ,'LineWidth', 1.5);
h(4) = plot(NaN,NaN,'Color',[148/255 0/255 211/255],'LineWidth', 1.5);
legend(h, 'Unirradiated (s2)','10^{10} ions/cm^2 (s2)','10^{11} ions/cm^2 (s2)','10^{12} ions/cm^2 (s2)', 'Location', 'eastoutside');


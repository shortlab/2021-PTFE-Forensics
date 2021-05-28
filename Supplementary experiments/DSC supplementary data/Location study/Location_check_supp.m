%% Location check for Apr 19 results
% Can some kind of location-based corrective alogorithm reduce the error bars in the main result plot?

%% Load data: Integrals from Heat2/Cool2_Apr19_finalAnalysis.m

load('heatIntegrals.mat')
% adjust y axis for enthalpy not peak area --> divide by heating rate 
qdot = 10/60; % 10 degreesC/min in degC/s
Heat = Int/qdot;

load('coolIntegrals.mat')
Cool = Int/qdot;

%% Split up data by fluence
H_c = Heat(1:20);
H_8 = Heat(21:32);
H_9 = Heat(33:44);
H_10 = Heat(45:56);
H_11 = Heat(57:68);

C_c = Cool(1:20);
C_8 = Cool(21:32);
C_9 = Cool(33:44);
C_10 = Cool(45:56);
C_11 = Cool(57:68);

%% Sample box numbers and position coordinates

% Sample coordinates
x_coord = [6,17,3,17,3,7,12,9,12,13,8,7,16,19,7,2,21,2,20,6,3,20,20,...
    8,15,8,18,5,18,13,13,10,4,19,19,9,14,9,4,19,4,14,9,14,5,18,5,18,...
    5,10,20,8,15,15,13,13,2,21,2,21,16,7,17,17,12,11,12,16];
x_c = [6,17,3,17,3,7,12,9,12,13,8,7,16,19,7,2,21,2,20,6];
x_8 = [3,20,20,8,15,8,18,5,18,13,13,10];
x_9 = [4,19,19,9,14,9,4,19,4,14,9,14];
x_10 = [5,18,5,18,5,10,20,8,15,15,13,13];
x_11 = [2,21,2,21,16,7,17,17,12,11,12,16];

y_coord = [1,2,3,4,5,1,2,3,4,1,2,4,5,1,6,6,5,4,3,2,1,2,4,1,2,3,3,2,...
    1,5,3,2,1,2,4,1,4,5,4,3,2,3,2,1,1,2,3,4,5,1,1,4,3,1,4,2,1,2,3,4,...
    2,3,3,1,3,2,1,4];
y_c = [1,2,3,4,5,1,2,3,4,1,2,4,5,1,6,6,5,4,3,2];
y_8 = [1,2,4,1,2,3,3,2,1,5,3,2];
y_9 = [1,2,4,1,4,5,4,3,2,3,2,1];
y_10 = [1,2,3,4,5,1,1,4,3,1,4,2];
y_11 = [1,2,3,4,2,3,3,1,3,2,1,4];

% Box number coordinating with DSC samples 1:20;1:12;1:12;1:12;1:12
boxNum = [1; 5; 9; 13; 17; 2; 6; 10; 14; 3; 7; 15; 19; 4; 23; 24; 20;
16; 12; 8; 1; 5; 13; 2; 6; 10; 12; 8; 4; 19; 11; 7; 1; 5; 13; 2; 14;
18; 16; 12; 8; 11; 7; 3; 1; 5; 9; 13; 17; 2; 4; 15; 11; 3; 14; 6; 1; 5;
9; 13; 6; 10; 12; 4; 11; 7; 3; 14];

label_c = {'1','5','9','13','17','2','6','10','14','3','7','15','19','4','23','24','20','16','12','8'};
label_8 = {'1', '5', '13', '2', '6', '10', '12', '8', '4', '19', '11', '7'};
label_9 = {'1', '5', '13', '2', '14', '18', '16', '12', '8', '11', '7', '3'};
label_10 = {'1', '5', '9', '13', '17', '2', '4', '15', '11', '3', '14', '6'};
label_11 = {'1', '5', '9', '13', '6', '10', '12', '4', '11', '7', '3', '14'};

% Check positions and box numbers
figure;
hold on
plot(x_c,y_c,'yo','MarkerFaceColor','y')
text(x_c+0.25,y_c,label_c,'Color','y','FontSize',6)
plot(x_8,y_8,'bo','MarkerFaceColor','b')
text(x_8+0.25,y_8,label_8,'Color','b','FontSize',6)
plot(x_9,y_9,'ro','MarkerFaceColor','r')
text(x_9+0.25,y_9,label_9,'Color','r','FontSize',6)
plot(x_10,y_10,'go','MarkerFaceColor','g')
text(x_10+0.25,y_10,label_10,'Color','g','FontSize',6)
plot(x_11,y_11,'mo','MarkerFaceColor','m')
text(x_11+0.25,y_11,label_11,'Color','m','FontSize',6)

% Figure properties
xlabel('x position')
ylabel('y position - along skived direction')
xlim([0,23])
ylim([0,9])

h = zeros(5, 1);
h(1) = plot(NaN,NaN,'yo','MarkerFaceColor','y');
h(2) = plot(NaN,NaN,'bo','MarkerFaceColor','b');
h(3) = plot(NaN,NaN,'ro','MarkerFaceColor','r');
h(4) = plot(NaN,NaN,'go','MarkerFaceColor','g');
h(5) = plot(NaN,NaN,'mo','MarkerFaceColor','m');

legend(h, {'Ctrl','10^{8}','10^{9}','10^{10}','10^{11}'})

%% Contour plot using cftool - Heating
[xData, yData, zData] = prepareSurfaceData( x_c, y_c, H_c );
% Set up fittype and options.
ft = 'linearinterp';
% Fit model to data.
[fitresult, gof] = fit( [xData, yData], zData, ft, 'Normalize', 'on' );
% Make contour plot.
figure( 'Name', 'Heat Data' );
h = plot( fitresult, [xData, yData], zData, 'Style', 'Contour' );
legend( h, 'Heat Data', 'H_c vs. x_c, y_c', 'Location', 'NorthEast' );
colorbar('Ticks',[-17.8, mean(H_c)-1*(std(H_c)),...
    mean(H_c),mean(H_c)+1*(std(H_c)),-15.8],...
         'TickLabels',{'-17.8','-1\sigma','Mean','+1\sigma','-15.8'})
% Label axes
xlabel('x-coordinate')
ylabel ('y-coordinate')
xlim([0,23])
ylim([0,9])
grid on
title('Interpolated control surface of Melting Enthalpies') 

%% Contour plot using cftool - Cooling
[xData, yData, zData] = prepareSurfaceData( x_c, y_c, C_c );
% Set up fittype and options.
ft = 'linearinterp';
% Fit model to data.
[fitresult, gof] = fit( [xData, yData], zData, ft, 'Normalize', 'on' );
% Make contour plot.
figure( 'Name', 'Cool Data' );
h = plot( fitresult, [xData, yData], zData, 'Style', 'Contour' );
legend( h, 'Cool Data', 'C_c vs. x_c, y_c', 'Location', 'NorthEast' );
colorbar('Ticks',[17.8, mean(C_c)-1*(std(C_c)),...
    mean(C_c),mean(C_c)+1*(std(C_c)),19.8],...
         'TickLabels',{'17.8','-1\sigma','Mean','+1\sigma','19.8'})
% Label axes
xlabel('x-coordinate')
ylabel ('y-coordinate')
xlim([0,23])
ylim([0,9])
grid on
title('Interpolated control surface of Cooling Enthalpies') 

%% Fits: linear flat surface - Heating

%Fit model: f(x,y) = p00 + p10*x + p01*y
coord = [1,2,3,4,5]; % for ctrl,1e8--1e11
p00_h = [-16.1, -16.43, -17.17, -21.91, -29.57];
p10_h = [-0.02633,-0.02388, 0.00309, 0.005772, -0.03262];
p01_h = [-0.207, -0.1706, -0.2443, 0.01937, 0.04934];
R2_h = [0.3864,0.3298,0.4923,0.004641, 0.07367];
RMSE_h = [0.4806,0.4551,0.373, 0.5884,0.8091];
std_h = [std(H_c),std(H_8),std(H_9),std(H_10),std(H_11)]; 

figure;
subplot(3,1,1)
plot(coord, p00_h)
title('Coefficients for f(x,y)=p00+p10*x+p01*y')
ylabel('Coefficient for heating')
legend('p00')
subplot(3,1,2)
hold on
plot(coord, p10_h)
plot(coord, p01_h)
legend('p10','p11')
ylabel('Coefficient for heating')
subplot(3,1,3)
hold on
plot(coord, R2_h)
plot(coord, RMSE_h)
plot(coord, std_h)
title('Residual metrics for fits')
xlabel('Fluence: ctrl, 1e8, 1e9, 1e10, 1e11')
ylabel('Residual metrics')
legend('R-square','RMSE','Std. dev.')

%% Fits: linear flat surface - Cooling

%Fit model: f(x,y) = p00 + p10*x + p01*y
coord = [1,2,3,4,5]; % for ctrl,1e8--1e11
p00_c = [18.04,18.2,18.59,22.67,28.77];
p10_c = [0.01371,0.009794,0.0179,0.01351,0.04495];
p01_c = [0.2234,0.2154,0.2134,-0.01971,-0.0442];
R2_c = [0.4268,0.3667,0.4114,0.02156,0.09812];
RMSE_c = [0.4545,0.4227,0.4324,0.6323,0.954];
std_c = [std(C_c),std(C_8),std(C_9),std(C_10),std(C_11)]; 

figure;
subplot(3,1,1)
plot(coord, p00_c)
title('Coefficients for f(x,y)=p00+p10*x+p01*y')
ylabel('Coefficient for cooling')
legend('p00')
subplot(3,1,2)
hold on
plot(coord, p10_c)
plot(coord, p01_c)
legend('p10','p11')
ylabel('Coefficient for cooling')
subplot(3,1,3)
hold on
plot(coord, R2_c)
plot(coord, RMSE_c)
plot(coord, std_c)
title('Residual metrics for fits')
xlabel('Fluence: ctrl, 1e8, 1e9, 1e10, 1e11')
ylabel('Residual metrics')
legend('R-square','RMSE','Std. dev.')

%% Contour plot using cftool - Heating of 1e11

[xData, yData, zData] = prepareSurfaceData( x_11, y_11, H_11 );
% Set up fittype and options.
ft = 'linearinterp';
% Fit model to data.
[fitresult, gof] = fit( [xData, yData], zData, ft, 'Normalize', 'on' );
% Make contour plot.
figure( 'Name', 'curved fit' );
h = plot( fitresult, [xData, yData], zData, 'Style', 'Contour' );
legend( h, 'curved fit', 'H\_11 vs. x\_11, y\_11', 'Location', 'NorthEast' );
grid on
colorbar('Ticks',[mean(H_11)-1*(std(H_11)),...
    mean(H_11),mean(H_11)+1*(std(H_11))],...
         'TickLabels',{'-1\sigma','Mean=-29.9','+1\sigma=0.8'})
xlabel('x-coordinate')
ylabel ('y-coordinate')
xlim([0,23])
ylim([0,9])
     
%% Fits: semi-quadratic in  surface - Heating

%Fit model: f(x,y) = p00 + p10*x + p01*y + p20*x^2 + p11*x*y
coord = [1,2,3,4,5]; % for ctrl,1e8--1e11
p00_h2 = [-15.54,-14.8,-16.36,-20.09,-28.01];
p10_h2 = [-0.1059,-0.3493,-0.1554,-0.2178,-0.4089];
p01_h2 = [-0.3092,-0.3009,-0.3265,-0.4709,-0.009248];
p20_h2 = [0.002073,0.0119,0.005918,0.004611,0.01687];
p11_h2 = [0.008959,0.01609,0.008214,0.04613,-0.0005295];
R2_h2 = [0.4142,0.8923,0.6254,0.4058,0.7831];
RMSE_h2 = [0.4999,0.2069,0.3633,0.5155,0.444];
std_h = [std(H_c),std(H_8),std(H_9),std(H_10),std(H_11)]; 

figure;
subplot(3,1,1)
plot(coord, p00_h2)
title('Coefficients for f(x,y)=p00+p10*x+p01*y+p20*x^2+p11*x*y')
ylabel('Coefficient for heating')
legend('p00')
subplot(3,1,2)
hold on
plot(coord, p10_h2)
plot(coord, p01_h2)
plot(coord, p20_h2)
plot(coord, p11_h2)
legend('p10','p11','p20','p11')
ylabel('Coefficient for heating')
subplot(3,1,3)
hold on
plot(coord, R2_h2)
plot(coord, RMSE_h2)
plot(coord, std_h)
title('Residual metrics for fits')
xlabel('Fluence: ctrl, 1e8, 1e9, 1e10, 1e11')
ylabel('Residual metrics')
legend('R-square','RMSE','Std. dev.')

%% Fits: semi-quadratic in  surface - Cooling

%Fit model: f(x,y) = p00 + p10*x + p01*y + p20*x^2 + p11*x*y
coord = [1,2,3,4,5]; % for ctrl,1e8--1e11
p00_c2 = [17.81,16.77,17.25,20.89,26.93];
p10_c2 = [0.05834,0.3568,0.2833,0.2538,0.4891];
p01_c2 = [0.2387,0.09583,0.34,0.3983,0.02375];
p20_c2 = [-0.001943,-0.01417,-0.01004,-0.006027,-0.01992];
p11_c2 = [-0.0001202,0.001205,-0.01265,-0.03944,0.0007155];
R2_c2 = [0.4368,0.9622,0.7334,0.2756,0.7905];
RMSE_c2 = [0.4796,0.1171,0.33,0.6169,0.5214];
std_c = [std(C_c),std(C_8),std(C_9),std(C_10),std(C_11)]; 

figure;
subplot(3,1,1)
plot(coord, p00_c2)
title('Coefficients for f(x,y)=p00+p10*x+p01*y+p20*x^2+p11*x*y')
ylabel('Coefficient for cooling')
legend('p00')
subplot(3,1,2)
hold on
plot(coord, p10_c2)
plot(coord, p01_c2)
plot(coord, p20_c2)
plot(coord, p11_c2)
legend('p10','p11','p20','p11')
ylabel('Coefficient for cooling')
subplot(3,1,3)
hold on
plot(coord, R2_c2)
plot(coord, RMSE_c2)
plot(coord, std_c)
title('Residual metrics for fits')
xlabel('Fluence: ctrl, 1e8, 1e9, 1e10, 1e11')
ylabel('Residual metrics')
legend('R-square','RMSE','Std. dev.')

%% For supplemental section: cm coordinates

% estimated based on tight grid with one punch per graph square and 0.635 cm/graph box
% Also estimating that sample matrix bottom left corner is at (2.5,2.5) graph boxes

% y coordinates (originally column #) from above corresponds to x[cm]
% (horizontal dimension), with 2.5 graph box shift and unit adjustment.
% x coordinates (originally rows) from above must be flipped and shifted.

y_c_cm = (23.5-[6,17,3,17,3,7,12,9,12,13,8,7,16,19,7,2,21,2,20,6])*0.635;
x_c_cm = (1.5 + [1,2,3,4,5,1,2,3,4,1,2,4,5,1,6,6,5,4,3,2])*0.635;
figure;
plot(x_c_cm, y_c_cm,'o')

%% For supplemental section: corrected orientation

[xData, yData, zData] = prepareSurfaceData( x_c_cm, y_c_cm, H_c );
% Set up fittype and options.
ft = 'linearinterp';
% Fit model to data.
[fitresult, gof] = fit( [xData, yData], zData, ft, 'Normalize', 'on' );
% Make contour plot.
figure;
subplot(1,2,1)
h = plot( fitresult, [xData, yData], zData, 'Style', 'Contour' );
legend( h, 'Heat Data', 'H_c vs. x_c, y_c', 'Location', 'NorthEast' );
colorbar('Ticks',[-17.8, mean(H_c)-1*(std(H_c)),...
    mean(H_c),mean(H_c)+1*(std(H_c)),-15.8],...
         'TickLabels',{'-17.8','-1\sigma','Mean','+1\sigma','-15.8'})
% Label axes
xlabel('x [cm] (skived direction)')
ylabel ('y [cm]')
xlim([0,6])
ylim([0,16])
grid on
title('Interpolated control surface of Melting Enthalpies') 

[xData, yData, zData] = prepareSurfaceData( x_c_cm, y_c_cm, C_c );
% Set up fittype and options.
ft = 'linearinterp';
% Fit model to data.
[fitresult, gof] = fit( [xData, yData], zData, ft, 'Normalize', 'on' );
% Make contour plot.
subplot(1,2,2)
h = plot( fitresult, [xData, yData], zData, 'Style', 'Contour' );
legend( h, 'Cool Data', 'C_c vs. x_c, y_c', 'Location', 'NorthEast' );
colorbar('Ticks',[17.8, mean(C_c)-1*(std(C_c)),...
    mean(C_c),mean(C_c)+1*(std(C_c)),19.8],...
         'TickLabels',{'17.8','-1\sigma','Mean','+1\sigma','19.8'})
% Label axes
xlabel('x [cm] (skived direction)')
ylabel ('y [cm]')
xlim([0,6])
ylim([0,16])
grid on
title('Interpolated control surface of Cooling Enthalpies') 





























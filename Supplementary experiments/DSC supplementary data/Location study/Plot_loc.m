% Script producing plots of location data
% All data interpolated and de-hooked

%% Sample notes

% Index = sample number, value = position number
sam2pos = [1 9 17 25 3 10 18 26 3 11 19 27 4 12 20 28 5 13 21 29 6 14 22 30 7 15 23 8 16 24];
% Index = pos, value = sample
pos2sam = [1 5 9 13 17 21 25 28 2 6 10 14 18 22 26 29 3 7 11 15 19 23 27 30 4 8 12 16 20 24];

% To get correct sample number index to match locations
r1 = [1 5 9 13 17 21];
r2 = [25 28 2 6 10 14];
r3 = [18 22 26 29 3 7];
r4 = [11 15 19 23 27 30];
r5 = [4 8 12 16 20 24];
c1 = [1 25 18 11 4];
c2 = [5 28 22 15 8];
c3 = [9 2 26 19 12];
c4 = [13 6 29 23 16];
c5 = [17 10 3 27 20];
c6 = [21 14 7 30 24];

%% For contour in cftool

x_row = [1, 2, 3, 5, 1, 2, 3, 5, 1, 2, 4, 5, 1, 2, 4, 5, 1, 3, 4, 5, 1, 3, 4, 5, 2, 3, 4, 2, 3, 4];
y_col = [1, 3, 5, 1, 2, 4, 6, 2, 3, 5, 1, 3, 4, 6, 2, 4, 5, 1, 3, 5, 6, 2, 4, 6, 1, 3, 5, 2, 4, 6];
% figure;
% plot(x_row, y_col, 'o')

% Based on image, coordinates from bottom left corner of red box in graph paper box units. 
% px locations obtained from GIMP and then coverted with 55 px/graph box
% and 0.635 cm/graph box, as well as orientation correction of 1362 in y.
x_coord = [137,621,1147,87,393,902,1403,385,647,1148,131,646,939,1412,379,921,1180,134,648,1156,1457,370,916,1398,153,626,1149,373,899,1404]/55*0.63;
y_coord = (1362-[203,363,576,1086,198,354,567,1065,199,362,874,1067,182,346,856,1055,177,602,852,1050,157,578,850,1050,387,578,838,370,575,828])/55*0.63;
% figure;
% plot(x_coord,y_coord, 'o')

%% Load corrected data (correct analysis with spline baseline) 5/28/20
% Already converted to enthalpies
[~,Cool_enthalpy] = Cool2_loc_adj();
[~,Heat_enthalpy] = Heat2_loc_adj();

%% Contour interpolated with cftool: cooling

% Fit: 'untitled fit 1'.
[xData, yData, zData] = prepareSurfaceData( x_coord, y_coord, Cool_enthalpy );
% Set up fittype and options.
ft = 'linearinterp';
% Fit model to data.
[fitresult, gof] = fit( [xData, yData], zData, ft );
% Make contour plot.
figure;
subplot(1,2,1)
h = plot( fitresult, [xData, yData], zData, 'Style', 'Contour' );
legend( h, 'Contour', 'Enthalpy vs. x, y', 'Location', 'NorthEast' );
% Label axes
grid on
colorbar
xlabel('x [cm] (skived direction)')
ylabel ('y [cm]')
xlim([0,18])
ylim([2,16])
grid on
title('Recrystallization enthalpies by location') 

%% Contour interpolated with cftool: heating

% Fit: 'untitled fit 1'.
[xData, yData, zData] = prepareSurfaceData( x_coord, y_coord, Heat_enthalpy );
% Set up fittype and options.
ft = 'linearinterp';
% Fit model to data.
[fitresult, gof] = fit( [xData, yData], zData, ft );
% Make contour plot.
subplot(1,2,2)
h = plot( fitresult, [xData, yData], zData, 'Style', 'Contour' );
legend( h, 'Contour', 'Enthalpy vs. x, y', 'Location', 'NorthEast' );
% Label axes
grid on
colorbar
xlabel('x [cm] (skived direction)')
ylabel ('y [cm]')
xlim([0,18])
ylim([2,16])
grid on
title('Melting enthalpies by location') 






%% Heating rate import data script
% Cycles:         Start row:      End Row:
% 1-2   500 KPS   3               6702
% 3-4   200 KPS   3               16752
% 5-6   100 KPS   3               3352
% 7-8   50 KPS    3               6702
% 9-10  10 KPS    3               3352
% 11    1 KPS     3               3352
% 12-15 500 KPS   3               6702

%% Heating rates correlating to data run number
qdot = [500 500 200 200 100 100 50 50 10 10 1 500 500 500 500];
path_main = 'C:\Users\Rachel\Documents\Rachel\MIT\MIT Research\Short Lab\';
path_specific = 'PTFE\Class irradiated FDSC samples\Heating rate\FlashDSC Heating Rate Try 1\';

%% 3352 length samples
run_3352 = [5 6 9 10 11];
qdot_3352 = [100 100 10 10 1];
s1 = 'cool';
s3 = '.txt';
d = length(run_3352);

% cool

T_3352_cool = zeros(3350,d);
Q_3352_cool = zeros(3350,d);
for i = 1:d
    s2 = num2str(run_3352(i));
    sample = [s1 s2 s3];
    file = [path_main path_specific sample];
    data = importFDSC(file,3,3352);
    T_3352_cool(:,i) = data(:,2);
    Q_3352_cool(:,i) = data(:,1);
end

% heat
s1 = 'heat';
T_3352_heat = zeros(3350,d);
Q_3352_heat = zeros(3350,d);
for i = 1:d
    s2 = num2str(run_3352(i));
    sample = [s1 s2 s3];
    file = [path_main path_specific sample];
    data = importFDSC(file,3,3352);
    T_3352_heat(:,i) = data(:,2);
    Q_3352_heat(:,i) = data(:,1);
end

%% 6702 length samples
run_6702 = [1 2 7 8 12 13 14 15];
qdot_6702 = [500 500 50 50 500 500 500 500];
s1 = 'cool';
s3 = '.txt';
d = length(run_6702);

% cool
T_6702_cool = zeros(6699,d);
Q_6702_cool = zeros(6699,d);
for i = 1:d
    s2 = num2str(run_6702(i));
    sample = [s1 s2 s3];
    file = [path_main path_specific sample];
    data = importFDSC(file,3,6701);
    T_6702_cool(:,i) = data(:,2);
    Q_6702_cool(:,i) = data(:,1);
end

% heat
s1 = 'heat';
T_6702_heat = zeros(6699,d);
Q_6702_heat = zeros(6699,d);
for i = 1:d
    s2 = num2str(run_6702(i));
    sample = [s1 s2 s3];
    file = [path_main path_specific sample];
    data = importFDSC(file,3,6701);
    T_6702_heat(:,i) = data(:,2);
    Q_6702_heat(:,i) = data(:,1);
end

%% 16752 length samples
run_16752 = [3 4];
qdot_16752 = [200 200];
s1 = 'cool';
s3 = '.txt';
d = length(run_16752);

% cool
T_16752_cool = zeros(16750,d);
Q_16752_cool = zeros(16750,d);
for i = 1:d
    s2 = num2str(run_16752(i));
    sample = [s1 s2 s3];
    file = [path_main path_specific sample];
    data = importFDSC(file,3,16752);
    T_16752_cool(:,i) = data(:,2);
    Q_16752_cool(:,i) = data(:,1);
end

% heat
s1 = 'heat';
T_16752_heat = zeros(16750,d);
Q_16752_heat = zeros(16750,d);
for i = 1:d
    s2 = num2str(run_16752(i));
    sample = [s1 s2 s3];
    file = [path_main path_specific sample];
    data = importFDSC(file,3,16752);
    T_16752_heat(:,i) = data(:,2);
    Q_16752_heat(:,i) = data(:,1);
end

%% Clear excess variables
clear d data file i path_main path_specific s1 s2 s3 sample




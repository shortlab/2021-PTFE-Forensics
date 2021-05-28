function masses = Cp_to_Mass(T_c,Q_c,T_h,Q_h,x) 
%FlashDSC analysis function for determining PTFE mass based on Cp away from rxns
% Follows methods described in Fast Scanning Calorimetry (Schick, 2016)
% with detailed description from (Cebe, 2015) 
% Assume: Cp looking good from 80-200 C
% Lit data: (Wunderlich, 1970) - Heat capacities of linear high polymers, pp. 331-335
% Input: T and Q data from cool3, heat4. Cool data should be loaded as is,
% and it will be flipped within the function. Also input x (samples).

%% Flip cool data and get sample number
% My data is in units of T [C], Q [mW]

Q_c = flipud(Q_c);
T_c = flipud(T_c);
n = length(x);

%% Data on cp from literature
% (Wunderlich, 1970) - Heat capacities of linear high polymers, pp. 331-335

T_K = [360; 370; 380; 390; 400; 425; 450];
Cp_caldegmol = [12.25; 12.4; 12.6; 12.7; 12.9; 13.4; 13.8];
nLit = length(T_K);

% convert to T [deg C], Cp specific [mJ/C/mg]
T_lit = T_K-273.15;
Cp_lit = Cp_caldegmol*4.184/50.01;

%% Adjust by symmetry, convert to Cp (not specific)
masses = zeros(nLit,n);

% Trim down between Tmin=80 C and Tmax=200 C
Tmin = 80;
Tmax = 200;

% Correct with heating rate +/- 500 Kps (flip signs bc definition of cp)
% Q [mW] / rate [K/s] = [mJ/degC]
heat = -500;
cool = 500;

for i = 1:n
    % cooling
    ind = find(T_c(:,i) > Tmin & T_c(:,i) < Tmax);
    T_c_trim = T_c(ind,i);
    Q_c_trim = Q_c(ind,i);
    fit_cool = [ones(length(T_c_trim),1) T_c_trim]\Q_c_trim;
    
    % heating
    ind = find(T_h(:,i) > Tmin & T_h(:,i) < Tmax);
    T_h_trim = T_h(ind,i);
    Q_h_trim = Q_h(ind,i);
    fit_heat = [ones(length(T_h_trim),1) T_h_trim]\Q_h_trim;
    
    % Definition of symmetry line y=m*x+b
    m_sym = (fit_cool(2)+fit_heat(2))/2;
    b_sym = (fit_cool(1)+fit_heat(1))/2;
    
% Subtract symmetry line from trimmed data and normalize by heating rate
    cp_c = (Q_c_trim - (b_sym + m_sym*T_c_trim))/cool;
    cp_h = (Q_h_trim - (b_sym + m_sym*T_h_trim))/heat;
    
    % Get mass m=by dividing myData/litData and convert to ng
    cp_avg = zeros(nLit,1);
    for j = 1:nLit
        cp_c_temp = interp1(T_c_trim,cp_c,T_lit(j));
        cp_h_temp = interp1(T_h_trim,cp_h,T_lit(j));
        cp_avg(j) = (cp_c_temp + cp_h_temp)/2; 
    end   
    masses(:,i) = cp_avg./Cp_lit*1e6;
end

end





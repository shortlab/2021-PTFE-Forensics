function [m,st] = fluence2Hcrys_poly2(fluence)
% Given a fluence, returns the expected mean and standard deviation based
% on DSC result (to be published) from Apr19 data. 
% Methodology: Uses chosen model to predict mean and 1 std
% Input: Fluence in [alphas/cm2]. Requires valid range: 0 or [1e8,1e11]
% Output: m - extrapolated expected mean, st - extrapolated expected
% standard deviation.

% Check if the requested fluence is within the valid range:
if ~isnumeric(fluence)
    error('fluence2Hcrys requires a numeric input.')    
elseif length(fluence) ~= 1
    error('fluence2Hcrys needs you to go one at a time.')
elseif (fluence < 1e8 || fluence > 1e11) && fluence ~= 0
    error('fluence2Hcrys does not like your value. Valid inputs are 0 or in [1e8,1e11].')
else  

% Perform the calculation:    
    
% Load the data:
load('coolData_processed.mat','Int_mean','Int_std');
% adjust y axis for enthalpy not peak area --> divide by heating rate 
qdot = 10/60; % 10 degreesC/min in degC/s
Int_mean = Int_mean/qdot;
Int_std = Int_std/qdot;

% Load model: (stored in fitresult2)
load('HcrysModel.mat','fitresult2');

% For fluence = 0 case:
if fluence == 0
    m = Int_mean(1);
    st = Int_std(1);
    p95 = [m-2*st, m+2*st];
    disp(p95)

% For fluence in range [1e8,1e11]    
else
    
    m = fitresult2(log10(fluence));
    p = predint(fitresult2,log10(fluence),0.68,'observation','off');
    st = m-p(1);
    p95 = predint(fitresult2,log10(fluence),0.95,'observation','off');
    disp(p95)
end

end

end
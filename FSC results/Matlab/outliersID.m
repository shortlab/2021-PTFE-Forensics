function accepted = outliersID(T,Q,x,th)
% Take data T,Q from slices x
% Return logical for accepted slices (1) vs identified outliers (0)
% Outliers ID'd based on damping of isotherm before cool3.
% Damping found by fitting a generic 2nd order damped transfer function
% response to the data, after it has been zeroed and normalized. 
% That last step is necessary to compare to the tf response to a step.
% th - the threshhold for acceptance. Recommended damping <= 1.1.

%% Zero and Normalize data

% T = T_nc_iso;
% Q = Q_nc_iso;
% x = x_nc;

% Use the steady state after tlow to get the height after zeroing.
tlow = 0.05;

Q_adj = zeros(size(T));
for i = 1:length(x)
    % shift all up to start at 0
    Q_temp = Q(:,i) - Q(1,i);
    
    % get height 
    ind = T(:,i) > tlow;
    h = mean(Q_temp(ind));

    % normalize 
    Q_adj(:,i) = Q_temp/h;
end

%%  Figure
% figure;
% hold on
% plot(T,Q_adj)
% 
% k = 1;
% z = 1;
% w = 500;
% s = tf('s');
% G = k*w^2/(s^2 + 2*z*w*s + w^2);
% y = step(G,T(:,1));
% plot(T(:,1),y,'k','LineWidth',2);
% h = plot(NaN,NaN,'k','LineWidth',2);
% legend(h,'Critically Damped Response')
% xlabel('Time [s]')
% ylabel('Heat Flow [mW]')
% title('Outlier Determination Methodology')

%% Get damping

damp = zeros(1, length(x));
for i = 1:length(x)
    fit = createFit_tf(T(:,i),Q_adj(:,i));
    damp(i) = fit.z;
end

%% Accept damp less than or equal to threshold.

accepted = damp <= th;

end




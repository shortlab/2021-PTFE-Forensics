function hooks = hook(T,Q,x)
% Based on more complicated ending thing.

%% Correctly orient data (assuming cooling)
Q = flipud(Q);
T = flipud(T);
n = length(x);

%% Hook height from cross over thing

hooks = zeros(1,n);

T_1 = 362;
T_2 = 367;
T_3 = 373.5;
T_4 = 374;

for i = 1:n
    ind_a = find(T(:,i) > T_1 & T(:,i) < T_2);
    ind_b = find(T(:,i) > T_3 & T(:,i) < T_4);
    
    T_left = T(ind_a,i);
    T_right = T(ind_b,i);
    Q_left = Q(ind_a,i);
    Q_right = Q(ind_b,i);
    
    % Fit left and right straights to line
    fr = [ones(length(T_right),1) T_right]\Q_right;
    fl = [ones(length(T_left),1) T_left]\Q_left;
    h = fl(2)*(fr(1)-fl(1))/(fl(2)-fr(2))+fl(1);
    hooks(i) = h-min(Q(:,i));    
end


















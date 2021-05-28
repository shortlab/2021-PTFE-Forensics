function y = transferFit(x,k,w,z) 
% Try to make a transfer function function

s = tf('s');
G = k*w^2/(s^2 + 2*z*w*s + w^2);
y = step(G,x);

end
function p = sigmoid(b,t)
%
% function p = sigmoid([a,m,n,tau],t)
%

A = b(1);
K = b(2);
B = b(3);
tau = b(4);

p = A + (K-A) ./ (1 + exp(-B*(t-tau)));

%p = 1 ./ (b(1)+exp(-b(2)*t + b(3))) + b(4);

%p = b(1).* ( (1 + b(2).*exp(-t./b(4))) ./ (1 + b(3).*exp(-t./b(4))));

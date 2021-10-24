function r = reds(alpha,range)
N=length(range);
r = [ones(N,1)*alpha [alpha-range]' zeros(N,1)];



% function r = reds(cInds)
% 
% r = [ones(20,1)*0.4 [0.39:-0.01:0.2]' zeros(20,1)];
% 
% if nargin > 0
%     r = r(cInds,:);
% end


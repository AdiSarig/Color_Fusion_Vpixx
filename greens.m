function g = greens(alpha,range,p)
N=length(range);
g = [[alpha-range]' ones(N,1)*alpha zeros(N,1)];

if nargin > 1
   for i=1:size(g,1)
       beta = polyval(p,g(i,1));
       g(i,:) = g(i,:) * beta;
   end
end


% function g = greens(cInds,p)
% 
% 
% g = [[0.39:-0.01:0.2]' ones(20,1)*0.4 zeros(20,1)];
% 
% if nargin > 1
%     for i=1:size(g,1)
%         beta = polyval(p,g(i,1));
%         g(i,:) = g(i,:) * beta;
%     end
% end
%     
% if nargin > 0 && ~isempty(cInds)
%     g = g(cInds,:);
% end

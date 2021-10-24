function [p,P,beta]=run_calibration

tryAgain = 1;
ind = 0;
base = 0.4;
range = [0.25:0.01:0.39];
while tryAgain
    ind=ind+1;
    [P{ind},beta{ind}] = findLumFunc_noCLUT([base base 0],2,1,range,[1 1 1]);
    tryAgain = input('Try again (1/0)? ');
end

cm = jet(ind);
figure
for i=1:ind
    plot(range,beta{i},'color',cm(i,:));
    hold on
    plot(range,polyval(P{i},range),'--','color',cm(i,:))
end
h = get(gca,'children');
legend(h([1:2:ind*2]),cellstr(strrep(num2str([1:ind]),' ','')'));

use_tries = input('Which estimates to include? ');

p = mean(cell2mat(P(use_tries)'),1);

plot(range,polyval(p,range),'r--','linewidth',2)
return
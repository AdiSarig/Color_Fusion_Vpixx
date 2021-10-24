base = 0.4;
range = [0.29:0.01:0.39];
cm = jet(ind);
figure
for i=1:ind
    %plot(range,beta{i},'color',cm(i,:));
    %hold on
    plot(range,polyval(P{i},range),'--','linewidth',3)
    hold on
end
h = get(gca,'children');
legend(h([1:ind]),cellstr(strrep(num2str([1:ind]),' ','')'),'location','northwest');
function fit_and_plot_test_results(mACC_same,subjNum,tag,lvls,mACC_opp)

fcn = @gabor_fit_fun;
Starting = [0.5,1,1,mean(lvls)];
t=[1:length(lvls)];

[BETA,R,J,COVB,MSE]=nlinfit(t,mACC_same,fcn,Starting);

% To check the fit
[Y] = fcn(BETA,t);

dY = [0 diff(Y)];
dY1 = find(dY<0.01);
ddY1 = [0 diff(dY1)];
[~,I] = max(ddY1);
% choose contrast range
%cInds = [dY1(I-1):dY1(I)];
h=figure;
hold on
plot(t,mACC_same,'*')
% plot(t,mACC_opp,'*')
hold on
plot(t,Y,'m')
plot(t(lvls),Y(lvls),'r.-','linewidth',2,'markersize',18);
grid on
set(gca,'xtick',[1:15])
set(gca,'fontsize',14)
title(sprintf('Subject # %03d: %s',subjNum,tag))

function [p,beta] = findLumFunc_noCLUT(base,gun1,gun2,range,rgbGamma)%% function coeff = findLumFunc(base,gun1,gun2,range,rgbGamma)%% Function to find beta such that lum(beta * C1) = lum(C2)% where C1 and C2 are two different RGB combinations.%% Range specifies that range of values ([0,1]) through which% electron gun1 is tested against electron gun 2 (whose intensity% stays fixed at gun2).% % gun1 and gun2 can be the number 1, 2, or 3 to indicate R, G, or B% respectively. gun1 and gun2 may not be the same.% % base is a 1 x 3 RGB triplet with one element set to zero. The other two% should be equal to each other. Think of this as the color mixture from% which you subtract a bit of one or the other of the two component colors% to move away from the intermediate color in one direction or the other.% So if the base is [0.5 0.5 0] then the intermediate color is yellow. If% you take away a bit of the red, say [0.4 0.5 0], then you go toward green,% and if you take away a bit of the green, say [0.5 0.4 0], then you go% toward red (orange really).%% 19 Oct 2005% Changed call to findIsoluminance2 (passed in 4th parameter), to tell% the program not to close the window after each run. This makes the% procedure more pleasant for the subject (doesn't switch back to the% Mac desktop in between each run, which tends to bother the eyes).%% Example calling syntax:% >> p = findLumFunc_noCLUT([0.5 0.5 0],2,1,[0.41:0.01:0.49],[1 1 1])%% NOTE: This function is only intended to work with color pairs, not% triplets. So you can mix green and red, or red and blue, or green and% blue, but one of the three must always be left out. If you want to use% more complicated combinations, then test your colors one at a time using% findIsoluminance.m. %% FURTHERMORE: This function has only ever been tested with combinations of% red and green. For other combinations - you are in uncharted territory.%if gun1 == gun2	error('gun1 and gun2 may not be the same')	returnenddisp('Press any key to begin...');pauseind = shuffle([1:length(range)]);w = initPsychToolboxWindows_noCLUT([],1);for i=1:length(range)	C1 = base; C1(gun1) = range(ind(i));	C2 = base; C2(gun2) = range(ind(i));	[beta(ind(i)),revList] = findIsoluminance_noCLUT(C2,C1,rgbGamma,w);     disp(i)endScreen('closeall');p=polyfit(range,beta,2);figureplot(range,beta);holdplot(range,polyval(p,range),'r')
%
% Script to create a paired set of reds and greens that are 
%     
%     

% define base and range
anchor = 0.42;
base = [anchor anchor 0];
range = [1/255:1/255:15/255];
nRange = length(range);

% vertical matching
pV = findLumFunc2(base,2,1,range,[1,1,1]);
cV = polyval(pV,range)';

% horizontal matching
pH = findLumFunc3(base,2,1,range,pV,[1,1,1]);
cH = polyval(pH,range)';

for i=1:length(range)
    greens(i,:) = [anchor-range(i) anchor+range(i) 0] * cV(i);
    reds(i,:) = [greens(i,2) greens(i,1) 0] * cH(i);
end

% Test it vertical
w = initPsychToolboxWindows_noCLUT([],1);
betaH=zeros(nRange,1);
betaH(1)=1;
for i=2:nRange
    betaH(i) = findIsoluminance_noCLUT(reds(i,:),reds(1,:),[1 1 1],w);
end
sca
reds = reds.*repmat(betaH,1,3)

% Test it horizontal
w = initPsychToolboxWindows_noCLUT([],1);
betaV=zeros(nRange,1);
for i=1:nRange
    betaV(i) = findIsoluminance_noCLUT(reds(i,:),greens(i,:),[1 1 1],w); %,w,rect);
end
sca
greens = greens.*repmat(betaV,1,3)

return



%%%%%%%% July 2009, ROUND 2

anchor = 0.4;
base = [anchor anchor 0]; % close match to blue
range = [2/255:2/255:20/255];

% vertical matching
pV = findLumFunc2(base,2,1,range,[1,1,1])
% pV =    -1.0006   -1.4480    1.0123
cV = polyval(pV,range)';

% horizontal matching
pH = findLumFunc3(base,2,1,range,pV,[1,1,1])
% pH =   4.0025    3.1315    1.0024
cH = polyval(pH,range)';

for i=1:length(range)
    GREENS(i,:) = [anchor-range(i) anchor+range(i) 0] * cV(i);
    REDS(i,:) = [greens(i,2) greens(i,1) 0] * cH(i);
end


% Test it horizontal
for i=1:10
    beta(i) = findIsoluminance2(reds(i,:),greens(i,:),[1 1 1]);
end

% adjust and check again
for i=1:10
    GREENS(i,:) = GREENS(i,:)*beta(i);
end


% Test it vertical
beta(1)=1;
for i=2:10
    beta(i) = findIsoluminance2(reds(i,:),reds(1,:),[1 1 1]);
end


% 
% runPilotTest
%
clear all
CONTRAST_RANGE = [1:15];

rng('shuffle','twister');
KbName('UnifyKeyNames');
% run polyfit here (dummy) so that loaded into memory for later
polyfit([1 2 3],[4 5 6],2);

% initialize the session structure
session = initSession('PilotTest:DCM');
subjNum = session.subjnum;
disp('OK, press any key to begin...')
pause

% [p,P,beta]=run_calibration; % leaves behind variables P and p
% save(sprintf('subj%02d_sess%02d_lumFunc_%s.mat',session.subjnum,session.sessnum,datestr(now,30)),'p','P','beta');

load subj00_sess00_lumFunc_20210827T155830.mat %use the reference value p 

% get default parameters
session.params = initParams(p);

params = session.params;
params.color.palette.reds = params.color.palette.reds(CONTRAST_RANGE,:);
params.color.palette.greens = params.color.palette.greens(CONTRAST_RANGE,:);


% Check that the subject can fuse the stimuli
% If fails after many attempts then send the subject home.
nAttemptsCheckFusion = CheckFusion;
%%%%%%%%%%%%%%%%%%%%
trials_preview = runFaceHousePreview_15(params);
trials_preview = runFaceHousePreview_13(params);
trials_preview = runFaceHousePreview_11(params);
%%%%%%%%%%%%%%%%%%%% 
CONTRAST_RANGE = [1:12]; %set range for main pilot test 
params.color.palette.reds = params.color.palette.reds(CONTRAST_RANGE,:);
params.color.palette.greens = params.color.palette.greens(CONTRAST_RANGE,:);
tmp = prepTrials_PilotTest(24,params);
midPt = floor(length(tmp)./2);
trials0 = tmp(1:midPt);
trials1 = tmp(1:midPt);
trials2 = tmp(midPt+1:end);
% practice block
[trials0,w] = oneRun('ignore',trials0,params,[],[1 1],1,false); %144 trials
pause(1)
Screen('CloseAll');
% run in two parts to give the subject a break

[trials1,w] = oneRun('ignore',trials1,params,[],[1 2],1,false); %144 trials
pause(1)
[trials2,w] = oneRun('ignore',trials2,params,w,[2 2],1,false);
trials = [trials1, trials2];

%function [trials,w]=oneRun(imgPath,trials,params,w,runNum,[nQ],eegBool)

Screen('CloseAll');

filePref = sprintf('subj%03d_PilotTest_%s',subjNum,datestr(now,30));

save(filePref,'trials*','session')

return

%analyze_pilotTest; %leaves behind figure handle h


% t=[1:nLvls];     
% h=figure;
% plot(t,mACC,'*')
% 
% saveas(h,[filePref '.fig'],'fig');

% disp('Done!')




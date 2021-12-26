% 
% runPilotTest
%
clear all
CONTRAST_RANGE = [1:15];
debug = false; % change to true to avoid running calibration and fusion

rng('shuffle','twister');
KbName('UnifyKeyNames');
% run polyfit here (dummy) so that loaded into memory for later
polyfit([1 2 3],[4 5 6],2);

%% Initialize Vpixx
isOpen = Datapixx('Open'); % check if Vpixx screen is connected
if ~isOpen
    error('VIEWPixx not connected! Please check connection and try again');
end

PsychDataPixx('Open');
% switch to ScanningBacklight mode for full illumination only after pixels stabilize 
PsychDataPixx('EnableVideoScanningBacklight'); % comment for photodiode test
ResponsePixx('Close'); % to make sure open doesn't fail
ResponsePixx('Open');
Datapixx('EnableDinDebounce');
Datapixx('RegWr');

% initialize digital output
Datapixx('SetDoutValues', 0);
Datapixx('RegWr');
WaitSecs(0.004);

%%
% initialize the session structure
session = initSession('PilotTest:DCM');
subjNum = session.subjnum;
disp('OK, press any key to begin...')
pause

if debug
    load subj00_sess00_lumFunc_20210827T155830.mat %use the reference value p
else
    [p,P,beta]=run_calibration; % leaves behind variables P and p
    save(sprintf('..%cdata%csubj%02d_sess%02d_lumFunc_%s.mat',filesep,filesep,session.subjnum,session.sessnum,datestr(now,30)),'p','P','beta');
end

% get default parameters
session.params = initParams(p, session);

params = session.params;
params.color.palette.reds = params.color.palette.reds(CONTRAST_RANGE,:);
params.color.palette.greens = params.color.palette.greens(CONTRAST_RANGE,:);


% Check that the subject can fuse the stimuli
% If fails after many attempts then send the subject home.
if ~debug
    nAttemptsCheckFusion = CheckFusion;
end
%%%%%%%%%%%%%%%%%%%%
% Contrast 15 preview
repeat_preview = true;
while repeat_preview
    trials_preview = runFaceHousePreview_15(params);
    repeat_preview = input('Was percentage below 90%? (1/0)');
end
% Contrast 13 preview
repeat_preview = true;
while repeat_preview
    trials_preview = runFaceHousePreview_13(params);
    repeat_preview = input('Was percentage below 90%? (1/0)');
end
% Contrast 11 preview
repeat_preview = true;
while repeat_preview
    trials_preview = runFaceHousePreview_11(params);
    repeat_preview = input('Was percentage below 90%? (1/0)');
end
%%%%%%%%%%%%%%%%%%%% 
CONTRAST_RANGE = [1:12]; %set range for main pilot test 
params.color.palette.reds = params.color.palette.reds(CONTRAST_RANGE,:);
params.color.palette.greens = params.color.palette.greens(CONTRAST_RANGE,:);
tmp = prepTrials_PilotTest(32,params); % changed to 32 from 24 by Adi Sarig 1 Dec 2021
midPt = floor(length(tmp)./2);
trials0 = tmp(shuffle(1:midPt));
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

filePref = sprintf('..%cdata%csubj%03d_PilotTest_%s',filesep,filesep,subjNum,datestr(now,30));

save(filePref,'trials*','session')

ResponsePixx('Close');
Datapixx('Close');

return

%analyze_pilotTest; %leaves behind figure handle h


% t=[1:nLvls];     
% h=figure;
% plot(t,mACC,'*')
% 
% saveas(h,[filePref '.fig'],'fig');

% disp('Done!')




% 
% runContrastSelectionTest
%
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
% load the session structure
subjNum = input('Subject number:');

try
    current_session_name = sprintf('subj00%d*PilotTest*', subjNum);
    filePatternSession = fullfile('..','data', current_session_name); % Change to whatever pattern you need.
    theSession = dir(filePatternSession);
    fullSessionName = fullfile(theSession.folder, theSession.name);
    load(fullSessionName)
    
    current_lumFunc_name = sprintf('subj0%d*lumFunc*', subjNum);
    filePatternLumFunc = fullfile('..','data', current_lumFunc_name); % Change to whatever pattern you need.
    theLumFunc = dir(filePatternLumFunc);
    fullLumFuncName = fullfile(theLumFunc.folder, theLumFunc.name);
    load(fullLumFuncName)
catch
    [file_list, path_n] = uigetfile('Load pilot test and lumFunc of current subject', 'MultiSelect','on');
    for file_ind = 1:length(file_list)
        fullName = fullfile(path_n, file_list(file_ind));
        load(fullName{1})
    end
end

% get default parameters
session.params = initParams(p, session);

% overwrite default contrast level with the selected one
session.params.color.contrastLevel = selected_contrast;
warning(['contrastLevel is set to ', num2str(selected_contrast)]);

cInd = session.params.color.contrastLevel;
session.params.color.red = session.params.color.palette.reds(cInd,:);
session.params.color.green = session.params.color.palette.greens(cInd,:);
params = session.params;

% Check that the subject can fuse the stimuli
% If fails after many attempts then send the subject home.
if ~debug
    nAttemptsCheckFusion = CheckFusion;
end

%%%%%%%%%%%%%%%%%%%% 
trials_contrast = prepTrials_ContrastTest(32,params); % changed to 32 from 24 by Adi Sarig 1 Dec 2021

[trials_contrast,w] = oneRun('ignore',trials_contrast,params,[],[1 1],1,false); %32 trials
pause(1)
Screen('CloseAll');

filePref = sprintf('..%cdata%csubj%03d_ContrastTest_%s',filesep,filesep,subjNum,datestr(now,30));

save(filePref,'trials_contrast','session')

ResponsePixx('Close');
Datapixx('Close');

return


function [trials] = prepTrials_ContrastTest(nTrialsPerLevel,params)
%
% function [trials] = prepTrials_faceHouseTest(nTrialsPerLevel,params)
%
% Takes a stimulus directory and returns a structure
% which is a shuffled list of trials for this experiment.
%
% This version is intended to go along with v02a_up
%
% nTrialsPerLevel defaults to 10
%
% conditions (stimCat = which way is the gabor leaning)
% ----------
%
% #   StimCat  DCF  L-eye   R-eye   contrast
% --  -------  ---  -----   -----   --------
% 
%  1   FACE     1    R        G       1
%  2   FACE     1    G        R       1
%  3   HOUSE    1    R        G       1
%  4   HOUSE    1    G        R       1
%  5   FACE     0    R        R       1
%  6   FACE     0    G        G       1
%  7   HOUSE    0    R        R       1
%  8   HOUSE    0    G        G       1
%  etc...
%
% 1 contrast level
% (32 trials per contrast level)
% \4 trials per condition above
%

nContrastLevels = 1; % only selected contrast level

nStimCat = 2; % number of stimulus categories (FH)
nConds = nContrastLevels * 2 * nStimCat; % the '2' is for all color combinations

nTrials = nContrastLevels * nTrialsPerLevel; % don't need to multiply x2 here
if ~((nTrials/4)==floor(nTrials/4))
    error('Number of trials must be divisible by 4 (2x the number of stimuli categories).')
end

disp(sprintf('\n%d contrast levels\n2 stimulus categories (Face, House)\n%d trials / contrast\n%d total trials\n',...
    nContrastLevels, nTrialsPerLevel, nTrials));
OK = '1'; %input('OK? ','s');
if ~(OK == '1' | OK == 'y' | OK == 'Y')
    disp('aborted')
    return
end

% ordered set of conditions
FH = repmat(['FFHH']',nTrials/4,1);
DCF = repmat([1 1 1 1 0 0 0 0]' ,nTrials/8,1);
lEyeColor = repmat(['RG']',nTrials/2,1); % background color in left eye
alpha = (params.color.contrastLevel*ones(1,8))'; % Color contrast level
alpha = repmat(alpha(:),nTrials/(8*nContrastLevels),1);
if ~(length(FH)==length(lEyeColor) && length(lEyeColor)==length(alpha))
    error('Something is wrong!');
end
condList = repmat([1:nConds]',nTrials/nConds,1);

d = dir('stimRegular/face_*.pcx');
faceStim = {d.name};
d = dir('stimRegular/house_*.pcx');
houseStim = {d.name};
faceInd=0; houseInd=0;

for i=1:nTrials
	trials(i).cond = condList(i); % condition #
    trials(i).stimCat = FH(i); % category of the stimulus (face/house/blank)
	trials(i).DCF = DCF(i); % 1/0 same / different stimulation (always DCF in this experiment)
	trials(i).lEyeBG = lEyeColor(i); % background color to right eye
    trials(i).contrastLevel = alpha(i); % color contrast level
    trials(i).preview = false;
    % CYCLE THROUGH FACE / HOUSE STIMULI
    [trials(i).imgFile, faceInd, houseInd] = ...
        select_faceHouse_image(FH(i),faceInd,houseInd,faceStim,houseStim); % name of image file(s) (cell array)
    trials(i).resp = []; % subject response
    trials(i).respc = ''; % character code for response
    trials(i).rt = []; % response time
	trials(i).acc = []; % accuracy
    trials(i).flipHor = []; % 1/0 flip horizontal
    trials(i).startTrial = 0; % time just before first flash in the trial
    trials(i).endTrial = 0; % time just after last flash in the trial
    trials(i).imgPath = './stimRegular/';  % to be assigned later
    trials(i).preview_15 = false;
    trials(i).preview_13 = false;
    trials(i).preview_11 = false;
    trials(i).post_test = params.is_post_test;
    
end

% SHUFFLE (shuffle)
trials = shuffle(trials);
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [fileName,faceInd,houseInd] = select_faceHouse_image(stimCat, faceInd, houseInd, faceStim, houseStim)

    nFace = length(faceStim);
    nHouse = length(houseStim);
    
    switch stimCat
        case 'F'
            faceInd = mod((faceInd+1)-1,nFace)+1;
            fileName = faceStim{faceInd};
        case 'H'
            houseInd = mod((houseInd+1)-1,nHouse)+1;
            fileName = houseStim{houseInd};
        otherwise
            error('Incorrect stimulus category. Only "F" and "H" are allowed.');
    end

        
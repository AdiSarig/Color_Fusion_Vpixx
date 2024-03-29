function [trials] = prepTrials_faceHousePreview_13(params)
%
% function [trials] = prepTrials_faceHousePreview()
%
% Takes a stimulus directory and returns a structure
% which is a shuffled list of trials for this experiment.
%
% This version is intended to go along with v02a_up
%
%
% conditions (stimCat = which way is the gabor leaning)
% ----------
%
% #   StimCat  DCF  L-eye   R-eye   contrast
% --  -------  ---  -----   -----   --------
% 
%  1   FACE     0    R        G       13
%  2   FACE     0    G        R       13
%  3   HOUSE    0    R        G       13
%  4   HOUSE    0    G        R       13

%  etc...
%
nContrastLevels = 1; % 13
nStimCat = 2; % number of stimulus categories: face / house 
nConds = 2 * nStimCat; % the '2' is for BG/FG color assigments
nItems = 24; % 12 faces /12 houses 

nTrials = 24; % hard-coded 
if ~((nTrials/2)==floor(nTrials/2))
    error('Number of trials must be divisible by 2.')
end

disp(sprintf('\n%d contrast levels\n%d stimulus categories (face, house)\n%d trials / contrast\n%d total trials\n',...
    nContrastLevels, nStimCat, nTrials));
OK = '1'; %input('OK? ','s');
if ~(OK == '1' | OK == 'y' | OK == 'Y')
    disp('aborted')
    return
end

% ordered set of conditions
FH = repmat(['FH']',nTrials/2,1);
lEyeColor = repmat(['RGGR']',nTrials/4,1);
alpha =[repmat(13,24,1)]; 
if ~(length(FH)==length(lEyeColor) && length(lEyeColor)==length(alpha))
    error('Something is wrong!');
end
% condList = repmat([1:nConds]',nTrials/nConds,1);

d = dir('stimRegular/face_*.pcx');
faceStim = {d.name};
d = dir('stimRegular/house_*.pcx');
houseStim = {d.name};

faceInd=0; houseInd=0;

for i=1:nTrials
% 	trials(i).cond = condList(i); % condition #
    trials(i).stimCat = FH(i); % category of the stimulus (face/house)
	trials(i).DCF = 0; % 0/1 same / different stimulation (always same in this experiment)
	trials(i).lEyeBG = lEyeColor(i); % background color to right eye
    trials(i).contrastLevel = alpha(i); % color contrast level
    if trials(i).stimCat == 'F'
        faceInd = randi([1 12],1,1); %randomly choose 6 from the 12, but possible to be the same stimuli for 3 times
        trials(i).imgFile = faceStim{faceInd}; % name of image file(s) (cell array)
    elseif trials(i).stimCat == 'H'
        houseInd = randi([1 12],1,1); %randomly choose 3 from the 14, but possible to be the same stimuli for 3 times
        trials(i).imgFile = houseStim{faceInd}; % name of image file(s) (cell array)
    else
        error('Something is wrong - no image file with that name.')
    end
    trials(i).resp = []; % subject response
    trials(i).respc = ''; % character code for response
    trials(i).rt = []; % response time
	trials(i).acc = []; % accuracy
    trials(i).flipHor = []; % 1/0 flip horizontal
    trials(i).startTrial = 0; % time just before first flash in the trial
    trials(i).endTrial = 0; % time just after last flash in the trial
    trials(i).imgPath = './stimRegular/';  % to be assigned later
    trials(i).preview_15 = false;
    trials(i).preview_13 = true;
    trials(i).preview_11 = false;
    trials(i).post_test = params.is_post_test;
end

% SHUFFLE (shuffle)
trials = shuffle(trials);

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        
function [trials, nBlocks, nTrialsPerBlock] = merge_trials(stimDirs,nContrastLevels,varargin)
%
% function [trials, nBlocks, nTrialsPerBlock] =
%     merge_trials(stimDirs,nContrastLevels,[nTrialsPerLevel],[nTrialsPerBlock])
%
% stimDirs is a cell array of strings, with the names of directories
% containing stimuli. The remaining parameters are the same as those passed
% to prepTrials_v02a_up.
%
% AS 17 June 2011
% 

TRL_IND = {};
cnt = 0;

for i=1:length(stimDirs)
    [TRIALS{i},nBLOCKS(i),nTRIALS_PER_BLOCK(i)] = ...
        prepTrials_v02a_up(stimDirs{i},nContrastLevels,varargin{:});
    [TRIALS{i}.imgPath] = deal(stimDirs{i});
    nTrials = length(TRIALS{i});
    TRL_IND{i} = [cnt+1:cnt+nTrials]';
    cnt = cnt+nTrials;
end

% interleave the trial indices
trlInd = Interleave(TRL_IND{:});
% concatenate the trials
trials = cat(2,TRIALS{:});
% sort the trials according to the interleaving
trials = trials(trlInd);

% make a new trial index for the shuffling
nTrials = length(trials);
trlInd = [1:nTrials];

% assign nBlocks and nTrialsPerBlock output parameters
nBlocks = nBLOCKS(1);
nTrialsPerBlock = sum(nTRIALS_PER_BLOCK);

% shuffle trials *within* blocks
for i=1:nBlocks
    trlInd((i-1)*nTrialsPerBlock+1:i*nTrialsPerBlock) = shuffle(trlInd((i-1)*nTrialsPerBlock+1:i*nTrialsPerBlock));
end
trials = trials(trlInd);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % add a block of blank trials for training
% % 30 June 2011 (AS)
% blankTrials = trials(1:nTrialsPerBlock);
% [blankTrials.contrastLevel] = deal(0);
% [blankTrials.imgFile] = deal('blank.pcx');
% [blankTrials.imgPath] = deal('.');
% [blankTrials.stimCat] = deal(nan);
% [blankTrials.cond] = deal(0);
% 
% % now stick the set of blank trials on to the beginning of trials
% trials = [blankTrials trials];
% nBlocks = nBlocks+1;

return
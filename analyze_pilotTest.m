if exist('session','var') && isstruct(session) && isfield(session,'subjnum')
    subjNum = session.subjnum;
else
    subjNum = input('Enter subject number: ');
end

nTrials = length(trials);

for i=1:nTrials
    tmp = KbName(trials(i).resp(1,:));
    if isempty(tmp)
        tmp = nan;
    elseif iscell(tmp)
        if length(tmp)==1
            tmp=tmp{1};
        else
            tmp=nan;
        end
    end
    switch tmp
        case {'f'}
            trials(i).respc = 'F';
        case {'h'}
            trials(i).respc = 'H';
        otherwise
            trials(i).respc = '?';
    end
end

sam_trials = trials([trials.DCF]==0);
opp_trials = trials([trials.DCF]==1);

sam_acc = [sam_trials.respc] == [sam_trials.stimCat];
sam_OK = ismember([sam_trials.respc],'FH');
opp_acc = [opp_trials.respc] == [opp_trials.stimCat];
opp_OK = ismember([opp_trials.respc],'FH');

lvls = unique([trials.contrastLevel]);
nLvls = length(lvls);
for i=1:nLvls
    mACC_sam(i) = mean(sam_acc(sam_OK & [sam_trials.contrastLevel]==lvls(i)));
    mACC_opp(i) = mean(opp_acc(opp_OK & [opp_trials.contrastLevel]==lvls(i)));
end

% if exist('doPlot')
%     if ~doPlot
%         return
%     end
% else
%     return
% end

%  sigmoid([0.5,1,1,8],[1:15])

fit_and_plot_test_results(mACC_sam,subjNum,'SAME',lvls,mACC_opp);

%fit_and_plot_test_results(mACC_opp,subjNum,'OPPOSITE',lvls);



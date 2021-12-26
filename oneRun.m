function [trials,w]=oneRun(ignore,trials,params,w,runNum,nQ,eeg)%% function [trials,w]=oneRun(imgPath,trials,params,w,runNum,[nQ],eeg)%% Runs one single block of trials.%% June 2021%% Parameters:%% imgPath is no longer used. It is in the trials structure for each trial.% trials is a trials structure% params is the params structure% w is a windows structure, with (presumably) an open active window ptr% runNum is a 1 x 2 vector with [current run #, total # of runs]% nQ is the number of responses to prompt for on each trial [defaults to 2]%if nargin < 6 % i.e. nQ not specified    nQ = 1; % default = 2end% constants and accumulators%	dsize = params.stimuli.imgSize; % desired image size on Screen in pixels (actual images should be of this size)    cmIND = init_cmIND; % color table indices	bgInd = cmIND.BG_ind; % for initial background color	textColor = cmIND.TEXT_ind; % text color    C1C2 = [cmIND.C1_ind cmIND.C2_ind];%% Stimulus presentation%	imgType = params.stimuli.imgType; % the kind of image being used (needed for routines like imread)% Now make the initial color map	cm = initColorMap(params,cmIND,[0 0 0],[0 0 0]);    save cm cm    %cm = round(jet(256)*255);   try%%%initPsychToolboxWindows(w,bgInd,cm,dsize,cmIND)%%%initPsychToolboxWindows_noCLUT(w,bgColor,[dsize],[cm],[cmIND])% initialize display (if w already defined, then w ignored)    [w,textPos] = initPsychToolboxWindows_noCLUT(w,bgInd,dsize,cm,cmIND);	clearEventQueue; % clear the keyboard buffer & wait all keys released        % instructions    [fusion_flag, abort_flag] = disp_instructions(params,trials,w);    if abort_flag        abortExperiment(w)    elseif fusion_flag        CheckFusion(w);    end% put the frames and fixation points on the Screen    srect = [1 1 w.dsize]-1;    Screen('DrawTexture',w.w,w.tex.justFrameAndFix,srect,w.lrect,[],0);    Screen('DrawTexture',w.w,w.tex.justFrameAndFix,srect,w.rrect,[],0);    Screen('flip',w.w,0,1);	drawText(w.w,sprintf('run %d of %d',runNum(1),runNum(2)),textPos(1),textColor,bgInd);	    Screen('flip',w.w);    if waitKeyCheckAbort(w) < 0        w=[];        return    end% start the run    ListenChar(2);	t0 = GetSecs; % start of this run	trials(1).tStartRun = t0;	Screen('DrawTexture',w.w,w.tex.frameOnly,srect,w.lrect,[],0);	Screen('DrawTexture',w.w,w.tex.frameOnly,srect,w.rrect,[],0);    Screen('flip',w.w,0,1);    WaitSecs(0.5);	drawText(w.w,'Ready...',textPos(1),textColor,cm(bgInd,:));    Screen('flip',w.w);        if waitKeyCheckAbort(w) < 0        w=[];        return    end	Screen('DrawTexture',w.w,w.tex.justFrameAndFix,srect,w.lrect,[],0);	Screen('DrawTexture',w.w,w.tex.justFrameAndFix,srect,w.rrect,[],0);    Screen('flip',w.w);    WaitSecs(0.5);       FlushEvents;% main loopfor i=1:length(trials)        if trials(i).contrastLevel==0        RED = [params.color.alpha params.color.alpha 0];        GREEN = RED;    else        RED = params.color.palette.reds(trials(i).contrastLevel,:);        GREEN = params.color.palette.greens(trials(i).contrastLevel,:);    end    cm = initColorMap(params,cmIND,RED,GREEN);    %Screen('LoadNormalizedGammaTable', w.w, cm);        % 1. read in and smooth the stimulus (randomly selected) using the current color map	t1 = GetSecs;		img = imread([trials(i).imgPath trials(i).imgFile],imgType);		% randomize figure/ground color assignment		rr = 2-(trials(i).lEyeBG=='R'); % 1 or 2        % object		[imgl,imgr] = genImages(img,C1C2(rr),C1C2((2-rr)+1),cmIND.FF_ind,1,trials(i).DCF);        w.tex.imgl = Screen('MakeTexture',w.w,ind2rgb(imgl,cm));        w.tex.imgr = Screen('MakeTexture',w.w,ind2rgb(imgr,cm));	tStimPrep = GetSecs-t1;    	% inter-trial interval    WaitSecs((params.timing.ITIbase-tStimPrep) + rand*params.timing.ITIvar);            %Set address from params    address = params.address;        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    % THE TRIAL...    [resp,rt,tOUT,tOUT_vpixx,accuracy, PAS]=oneTrial(w,params.timing,1/params.screen.res.hz,nQ,trials(i),address,eeg,params);    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    trials(i).resp = resp;    trials(i).rt = rt;    trials(i).timingHistory = tOUT;    trials(i).timingHistoryVpixx = tOUT_vpixx;    trials(i).acc = accuracy;    trials(i).PAS = PAS;    if ~isempty(resp)        if resp == params.resp.exit            abortExperiment(w)        end    end    % Maintenance break    [keyIsDown, ~, keyCode] = KbCheck;    if keyIsDown        if strcmpi(KbName(keyCode),'m') % m for maintenance            stopForMaintenance(w, params);        end    end    %	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    	% put the frames only (no fixation) on the Screen	Screen('DrawTexture',w.w,w.tex.justFrameAndFix,srect,w.lrect,[],0);	Screen('DrawTexture',w.w,w.tex.justFrameAndFix,srect,w.rrect,[],0);    Screen('flip',w.w);    % loop and do it againend % for%%%%%catch%%%%%    ListenChar(0);    ShowCursor;    Screen('closeall');    if ~isempty(w)%        Screen('LoadNormalizedGammaTable', 0, w.defcm);    end    rethrow(lasterror);%%%end%%%    % cleanup and return    ListenChar(0);    return%--------------------------------------------------------------------------function clearEventQueue        while KbCheck        % just wait    end    %--------------------------------------------------------------------------function drawText(w,text,textPos,textColor,bgColor)	% draw text indicating the current adjustment increment	Screen('TextSize',w,textPos.size);	Screen('TextStyle',w,0);	% clear the previous text%	FILL = length(text)*10;%	Screen('FillRect',w,bgColor,[textPos.L.x,textPos.L.y-10,textPos.L.x+FILL,textPos.L.y]);%	Screen('FillRect',w,bgColor,[textPos.R.x,textPos.R.y-10,textPos.R.x+FILL,textPos.R.y]);	% draw the new text	Screen('DrawText',w,text,textPos.L.x,textPos.L.y,textColor);	Screen('DrawText',w,text,textPos.R.x,textPos.R.y,textColor);%--------------------------------------------------------------------------	function cm = initColorMap(params,cmIND,C1,C2)	cm(cmIND.C1_ind,:)=C1;	cm(cmIND.C2_ind,:)=C2;	cm(cmIND.FF_ind,:) = params.color.ffColor; % frame and fixation color	cm(cmIND.BLACK_ind,:) = [0 0 0];	cm(cmIND.WHITE_ind,:) = [1 1 1];	cm(cmIND.BG_ind,:) = params.color.bgColor;	cm(cmIND.TEXT_ind,:) = params.color.textColor;    cm(cmIND.RED_ind,:) = [0.5 0 0];    % invert CM for Windows    cm=round(cm*255);%--------------------------------------------------------------------------    function cmIND = init_cmIND	cmIND.C1_ind = 2;	cmIND.C2_ind = 3;	cmIND.FF_ind = 4;	cmIND.WHITE_ind = 1;	cmIND.BLACK_ind = 256;	cmIND.BG_ind=128;	cmIND.TEXT_ind=127;    cmIND.RED_ind = 5;%--- END ------------------------------------------------------------------
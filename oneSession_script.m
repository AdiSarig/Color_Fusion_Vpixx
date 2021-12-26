%% This script runs one session of the triangulation paradigm.% For each block (run) of trials, calls oneRun.m and also saves backup of% data from that run.%% It is assumed that a session object already exists and has been% intialized. This is a script instead of a function to make it easier to% resume the session in the event of an error or problem.%% 10 June 2021%%%%%%%%%%%%%%%%%%%%%%%%%%%session.imgPath = imgPath;%%%%%%%%%%%%%%%%%%%%%%%%%%nRuns = 10;nTrialsPerRun = 120;[TRIALS] = prepTrials(nRuns,nTrialsPerRun,session);session.nRuns = nRuns;session.nTrialsPerRun = nTrialsPerRun;% setting up TTL triggers to send from STIM to RECORD (EEG); this is so we% know when events happen in the recorded EEG signalconfig_io;try    w=[];    for iRun=1:nRuns         runNum = [iRun, nRuns];        trialsThisRun = [(iRun-1)*nTrialsPerRun+1 : iRun*nTrialsPerRun];        [trials,w]=oneRun(imgPath,TRIALS(trialsThisRun),session.params,w,runNum,0,true);        if isempty(w)            Screen('closeall'); % just in case!            warning('Aborted. You may still want to save a final copy of the data.')            return        end        % emergency backup save        save(sprintf('subj%02d_sess%02d_run%02d_%s.mat',session.subjnum,session.sessnum,iRun,datestr(now,30)),'trials');        session.run(iRun).trials = trials;        WaitSecs(0.5);        %session.run(iRun).checkFusion = CheckFusion(w);    end        w =  (w);    catch    ListenChar(0);    ShowCursor;    Screen('closeall');    rethrow(lasterror);end% almost final save of data (still needs to run the posttest)save(sprintf('..%cdata%csubj%02d_sess%02d_%s_%s.mat',filesep,filesep,session.subjnum,...    session.sessnum,'main',datestr(now,30)),'session');% w = closePsychToolboxWindows(w);ListenChar(0);ShowCursor;Screen('closeall');%-- END --%
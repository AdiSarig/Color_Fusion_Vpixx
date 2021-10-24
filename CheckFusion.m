function nAttempts = CheckFusion(w)%% Just put up the frame and fixation.% Check that subject can see which way the 'E' is pointing.%imgSize = [175, 175];nAttempts = 0;nCorrectInRow = 0;FF_ind = 2;BG_ind = 1;KbName('UnifyKeyNames');keyNames = keyNamesOnThisComputer;ESCAPE_KEY = keyNames.escape;% make sure no keys down[k,s,c] = KbCheck;while k    [k,s,c] = KbCheck;end    % This is monitor / resolution / viewing distance dependent	bgColor = [0,0,0]; % background color    ffColor = [0,0,0.8]; % frame and fixation color% open main window & get needed constants    if nargin<1 || isempty(w)        if length(Screen('Screens'))>1            dev = 1;        else            dev = 0;        end        [w.w,w.rect]=Screen('OpenWindow',dev, bgColor,[],[],2);        closeOnReturn = true;        HideCursor        ListenChar(2); % suppress output to command window    else        closeOnReturn = false;    end	xmax=w.rect(3); ymax=w.rect(4);	[lctr,rctr]=IMG_POS(xmax,ymax);% get positions of l and r images	lrect=[lctr-floor(imgSize/2) lctr+floor(imgSize/2)];	rrect=[rctr-floor(imgSize/2) rctr+floor(imgSize/2)];% add frame and fixation to the background screen so only the image itself flickers% place stimuli on background, unform stimulation, and mask screens    justFrame = AddFrameAndFix(zeros(imgSize),FF_ind-1,'no fix');OPTIONS = {'up','down','left','right'};KEYS = {keyNames.upArrow, keyNames.dnArrow, keyNames.ltArrow, keyNames.rtArrow};while nCorrectInRow < 3    % choose one of the four images at random    SEL = floor(rand*4)+1;    IMG_FILE_LEFT = sprintf('E_%s_lEye',OPTIONS{SEL});    IMG_FILE_RIGHT = sprintf('E_%s_rEye',OPTIONS{SEL});    [limg,cm]=imread(IMG_FILE_LEFT,'pcx');    %	limg=ind2rgb(limg,m);    [rimg,cm]=imread(IMG_FILE_RIGHT,'pcx');	    %	rimg=ind2rgb(rimg,m);    cm(FF_ind,:) = ffColor;    cm(BG_ind,:) = bgColor;    limg = AddFrameAndFix(limg,FF_ind-1,'no fix');    rimg = AddFrameAndFix(rimg,FF_ind-1,'no fix');    cm = round(cm*255);    texL = Screen('MakeTexture',w.w,ind2rgb(limg,cm));    texR = Screen('MakeTexture',w.w,ind2rgb(rimg,cm));        Screen('DrawTexture',w.w,texL,[],lrect);    Screen('DrawTexture',w.w,texR,[],rrect);    Screen('flip',w.w,0,1);    [s,c] = KbWait;    if strcmp(KbName(c),ESCAPE_KEY)        closeOnReturn = true;        break    elseif strcmp(KbName(c),KEYS{SEL})        nCorrectInRow = nCorrectInRow+1;    else        nCorrectInRow = 0;    end    nAttempts = nAttempts + 1;    % blank the screen in between each attempt    Screen('flip',w.w);    WaitSecs(0.25);endif closeOnReturn    ShowCursor;    ListenChar(1);	Screen('CloseAll');endreturn%---------------------------------------------------------------%---------------------------------------------------------------    
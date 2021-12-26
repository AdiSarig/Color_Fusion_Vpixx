function params = params_Psych131(p, session)
%
% Parameters for the Psych 131 testing room
% May 2021
%
% CHANGE LOG
%

cRange = [1./128:1./128:0.13];
nLvls = length(cRange);
input(sprintf('color params: %d levels (any key to continue...)',nLvls))

% display is   53 cm  x   30 cm
%            1920     x 1080 pixels
% roughly 36 pixels per centimeter
%
% viewing distance is about 57 cm
% at that distance 1 cm ~ 1 degree
%

ppd=36; % pixels per degree on screen (rounded to nearest pixel)
cw28 = round(ppd*0.5); % pixel width of one character at 28 point font size
ch28 = round(ppd*0.6);


% screen
params.screen.res = Screen(0,'resolution'); % 
params.screen.rect = [0 0 params.screen.res.width params.screen.res.height];
%params.screen.res.hz = 60; % hz is not set on Mac's
params.screen.viewDist_cm = 57; % viewing distance
params.screen.dim.cm = [53,30]; % screen dimensions in cm [W, H]
params.screen.dim.pix = [params.screen.res.width params.screen.res.height]; % screen dimensions in pix
params.screen.dim.deg = [53,30];% screen dimensions in deg at 50cm
params.screen.dim.ppd = ppd; % pixels per degree at 50cm view distance
params.screen.pos.CTR = round(params.screen.dim.pix/2); % center of the screen in pixels
params.screen.pos.txtOffset = [-round(cw28/2),-round(ch28/2)]; % lower left corner of 1deg square centered at x,y
params.screen.pos.FIX = params.screen.pos.CTR + params.screen.pos.txtOffset;
params.screen.rgbGamma = [1 1 1]; % gamma correction, if any

% trigger codes
params.address = hex2dec('DFC8'); % address for sending codes from parallel port
params.trig.resp = convertTriggers(40);
params.trig.resp_CR = convertTriggers(41);
params.trig.resp_miss = convertTriggers(42);
params.trig.resp_hit = convertTriggers(43);
params.trig.resp_FA = convertTriggers(44);
params.trig.resp_error = convertTriggers(49);

% timing
params.timing.nON = 12; %
params.timing.nOFF = 24; % 
params.timing.nFlashReps = 1; %
params.timing.ITIbase = 0.5; % in seconds (was 1, changed to 0.5 by Adi Sarig, 1 Dec 2021)
params.timing.ITIvar = 0.25; % in seconds (was 0.5, changed to 0.25 by Adi Sarig, 1 Dec 2021)
params.timing.fixation = 0.500; % onset of fixation prior to start of trial
params.timing.timeLimit = 1.0; % time limit for responding: typically 750 ms
params.timing.timeoutDuration = 2; % duration of timeout, in case response is late


% stimuli & text 
params.stimuli.imgSize = [175 175];
params.stimuli.imgType = 'pcx';

% blue dot specs
params.blueDot.prop = .15;
params.blueDot.duration = params.timing.nON; %in refreshes, 100ms on 120hz monitor

% colors
params.color.alpha = 0.4;
params.color.red = [];
params.color.green = [];
params.color.palette.reds = reds(params.color.alpha,cRange);
params.color.palette.greens = greens(params.color.alpha,cRange,p);
params.color.p = p;
params.color.contrastLevel = 7;
warning('contrastLevel is set to 7');

% params.color.reds = reds(cInds);
% params.color.greens = greens(cInds,Jug_lumFunc);
params.color.bgColor = [0, 0, .8]; % changed from 0.9 to 0.8 on 18 March 2010
params.color.ffColor = [0, 0, 0]; % color of the frame and fixation
params.color.textColor = [0.15 0.15 0.15]; % color of text
% params.REDS = reds; % keep the full set for the record
% params.GREENS = greens([],ens_p); % keep the full set for the record
params.cInds = []; % indices into REDS and GREENS to use for this experiment

%params.stimuli.fixColor = 0;
%params.stimuli.fixSize = 7; % should always be an odd number
%params.stimuli.fixPenWidth = 1; % in pixels
%params.stimuli.bringToFixDur = 1; % seconds
%params.stimuli.bringToFixEcc = 100; % initial eccentricity
%params.stimuli.bringToFixPtColor = 0;

% vpixx pixel triggers
bg = round(256*params.color.bgColor(3));
vpix_trig=uint8([0 0 0 0 0 0 0 0,...
    0 0 0 0 0 0 0 0,...
    0 0 0 0 0 0 0 0;...
    0 0 0 0 0 0 0 0,...
    0 0 0 0 0 0 0 0,...
    0 0 0 0 0 0 0 0;...
    bg+2 bg-2 bg+2 bg-2 bg+2 bg-2 bg+2 bg-2,...
    bg+2 bg-3 bg+2 bg-3 bg+2 bg-3 bg+2 bg-3,...
    bg+3 bg-2 bg+3 bg-2 bg+3 bg-2 bg+3 bg-2]);

params.ptrig.image = vpix_trig(:,1:8);       % image trigger
params.ptrig.fixation = vpix_trig(:,9:16);   % fixation trigger

if mod(session.subjnum, 2) == 0
    params.resp.house = 1; % most left
    params.resp.face = 4; % 3rd from left
    params.instructions.prev = imread(fullfile(pwd,'instructions','prev_group1.tif'));
    params.instructions.main = imread(fullfile(pwd,'instructions','main_group1.tif'));
else
    params.resp.house = 4; % 3rd from left
    params.resp.face = 1; % most left
    params.instructions.prev = imread(fullfile(pwd,'instructions','prev_group2.tif'));
    params.instructions.main = imread(fullfile(pwd,'instructions','main_group2.tif'));
end
params.instructions.dot = imread(fullfile(pwd,'instructions','main.tif'));
params.instructions.maintenance = imread(fullfile(pwd,'instructions','maintenance_break.tif'));
params.instructions.break_over = imread(fullfile(pwd,'instructions','break_over.tif'));
params.instructions.PAS_scale = imread(fullfile(pwd,'instructions','PAS_scale.tif'));
params.instructions.PAS_info = imread(fullfile(pwd,'instructions','PAS_info.tif'));
params.resp.dot = 2; % most right
params.resp.exit = 5; % top
params.resp.fusion_check = 3; % 2nd from left

params.is_post_test = false;

end
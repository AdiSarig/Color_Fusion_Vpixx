%
% Face-house-blank staircase
%
% On each trial:
%   select a random stimulus from a random category (FHB)
%   present stimulus at current contrast level
%   IF stimulus was a blank
%   THEN do nothing (just continue)
%   ELSE (i.e. face or house stimulus)
%       IF opposite-color mode
%       THEN
%           IF (response is F or H) and correct
%           THEN decrease contrast one notch (for next trial)
%           ELSE 
%               IF response = blank or is incorrect
%               THEN do nothing
%       ELSE (i.e. same-color mode)
%           IF (response is F or H) and correct
%           THEN do nothing
%           ELSEIF (response is F or H) and incorrect
%           THEN increase contrast one notch
%           ELSEIF response is blank
%           THEN increase contrast one notch
%
%   REPEAT UNTIL 10 REVERSALS
%   TAKE MEAN OF LAST 6 reversals
%               
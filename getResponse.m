function [Response, RTfromStart, accuracy] = getResponse(hasProbe, windowStart, respDur, respButton)
% This function retrieves the response from the device log at the end of
% each trial
%
% Inputs:
% hasProbe: logical - whether or not subjects were supposed to respond to
% the trial
% windowStart: beginning of response window in Vpixx time
% respDur: maximal allowed response window in seconds
% respButton: Number of response box button allocated for the condition.
%
% Outputs:
% Response: Which response button the subjects pressed (if not pressed
% returns -1)
% RTfromStart: When the subjects responded in Vpixx time (if they didn't
% respond returns -1)
% accuracy: Returns a string describing accuracy (hit / miss / correct
% rejection / false alarm / wrong button)


numFrames = 1; % collect only press, not release

Datapixx('RegWrRd');
status = Datapixx('GetDinStatus');
if status.newLogFrames >= numFrames
    % Retrieve logged data:
    [data, RTfromStart] = Datapixx('ReadDinLog', numFrames);
    
    % Decode into button state vector:
    Response = zeros(length(data), 5);
    for i=1:length(data)
        for j=0:4
            Response(i, j+1) = ~bitand(data(i), 2^j);
        end
    end
    Response = find(Response);
    
    if length(Response) == 1 % check no more than one button was pressed
        if (Response == respButton) && hasProbe
            if RTfromStart - windowStart < respDur
                accuracy = 'hit';
            else
                accuracy = 'miss'; % exceeded time limit
            end
        elseif (Response == respButton) && ~hasProbe
            accuracy = 'FA'; % false alarm
        else
            accuracy = 'error';
        end
    else
        accuracy = 'error';
    end
else % No response
    %----send trigger
    Response    = -1;
    RTfromStart = -1;
    if hasProbe
        accuracy = 'miss';
    else
        accuracy = 'CR'; %correct rejection
    end
end

end

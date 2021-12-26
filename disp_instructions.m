function [fusion_flag, abort_flag] = disp_instructions(params,trials,w)
% This function displays instructions and waits for a response via vpixx
% response box

ResponsePixx('StartNow',1);

if any([trials.preview_11 trials.preview_13 trials.preview_15])
    infoTex =  Screen('MakeTexture',w.w,params.instructions.prev);
elseif isfield(trials,'blueDot') && any([trials.blueDot])
    infoTex =  Screen('MakeTexture',w.w,params.instructions.dot);
else
    infoTex =  Screen('MakeTexture',w.w,params.instructions.main);
end

Screen('DrawTexture',w.w, infoTex);
Screen('Flip',w.w);
resp = ResponsePixx('GetLoggedResponses',2); % unlimited wait for any response
resp = find(resp(1,:));
fusion_flag =  resp == params.resp.fusion_check;
abort_flag =  resp == params.resp.exit;

if any([trials.post_test])
    infoTex =  Screen('MakeTexture',w.w,params.instructions.PAS_info);
    Screen('DrawTexture',w.w, infoTex);
    Screen('Flip',w.w);
    ResponsePixx('GetLoggedResponses',2); % unlimited wait for any response
end

ResponsePixx('StopNow',1); % stop response collection

end


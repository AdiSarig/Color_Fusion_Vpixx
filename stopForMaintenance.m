function stopForMaintenance(w, params)

Screen('Flip',w.w);
maintenanceTex =  Screen('MakeTexture',w.w,params.instructions.maintenance);
Screen('DrawTexture',w.w, maintenanceTex);
Screen('Flip',w.w);
[~, key_code] = KbWait([],2);
fusion_flag = strcmpi(KbName(key_code),'y');

if fusion_flag
    CheckFusion(w);
end

break_overTex =  Screen('MakeTexture',w.w,params.instructions.break_over);
Screen('DrawTexture',w.w, break_overTex);
Screen('Flip',w.w);
KbWait([],2);

end
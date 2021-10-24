function err = waitKeyCheckAbort(w)

    [k,c,s]=KbWait;
    if strmatch('ESC',upper(KbName(c))) % escape = abort
        err = -1;
        ListenChar(0);
        ShowCursor;
        Screen('closeall');
    else
        err = 0;
    end

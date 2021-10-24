function drawBlueDot(w,probeLoc)

    % [xCenter, yCenter] = RectCenter(session.windowRect);
    dotColor = [255 0 0 0];
    dotSizePix = 8;
    
    dotXpos = probeLoc(1);
    dotYpos = probeLoc(2);

    Screen('DrawDots', w, [dotXpos dotYpos], dotSizePix, dotColor, [], 2);

end

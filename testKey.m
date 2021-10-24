function [keyNum,keyChar] = testKey

pause(0.5);
[~,c,~] = KbWait;
keyNum = find(c);
keyChar = KbName(c);

return
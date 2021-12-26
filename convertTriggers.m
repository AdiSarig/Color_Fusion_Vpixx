function [fullDec] = convertTriggers(trigDec)
% Convert the decimal triggers to fit the vpixx output format

tempBin = dec2bin(trigDec,8);
fullBin = dec2bin(0,24);
fullBin(8:2:22) = tempBin(:);

fullDec = bin2dec(fullBin);

end


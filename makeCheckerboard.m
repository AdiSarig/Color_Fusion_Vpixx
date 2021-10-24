function chex = makeCheckerboard(checkSize,gridSize,varargin)
%
% function chex = makeCheckerboard(checkSize,gridSize,[groutWidth])
%
% Make a one's and zero's checkerboard matrix with each check of size
% checkSize, and the whole grid of size gridSize*2 .* checkSize.
%
% groutWidth refers to the width of a thin line separating the chex (like
% the grout in a tile floor). The grout is coded with a 0.5.
%

groutCode=0.5;

if ~isempty(varargin)
    groutWidth = varargin{1};
else
    groutWidth = 0;
end


if groutWidth
    oneCheck = [ones(checkSize),ones(checkSize(1),groutWidth)*groutCode,zeros(checkSize),ones(checkSize(1),groutWidth)*groutCode;...
                ones(groutWidth,checkSize(2)*2+groutWidth*2)*groutCode;
                zeros(checkSize),ones(checkSize(1),groutWidth)*groutCode,ones(checkSize),ones(checkSize(1),groutWidth)*groutCode;...
                ones(groutWidth,checkSize(2)*2+groutWidth*2)*groutCode];

    chex = repmat(oneCheck,gridSize);    
else
    oneCheck = [ones(checkSize),zeros(checkSize);...
                zeros(checkSize),ones(checkSize)];

    chex = repmat(oneCheck,gridSize);
end

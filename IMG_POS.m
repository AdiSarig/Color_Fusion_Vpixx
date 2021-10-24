function [lctr,rctr]=IMG_POS(xmax,ymax)

% This works for Psych 131
lctr=[round(5*xmax/16) round(ymax/2)];
rctr=[round(11*xmax/16) round(ymax/2)];


% This works for up to 200 x 200
% lctr=[round(27.5*xmax/64) round(ymax/2)];
% rctr=[round(36.5*xmax/64) round(ymax/2)];

% This is for 240 x 240
%lctr=[round(23*xmax/64) round(ymax/2)];
%rctr=[round(41*xmax/64) round(ymax/2)];

% Best for 200x200
%lctr=[round(24*xmax/64) round(ymax/2)];
%rctr=[round(40*xmax/64) round(ymax/2)];

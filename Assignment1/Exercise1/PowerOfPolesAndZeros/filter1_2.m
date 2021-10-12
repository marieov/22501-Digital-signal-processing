clear; close all;

% Zeros:
%fz = [3*pi/8, 2*pi/8, pi/8]; % High pass filter
fz = [5*pi/8, 6*pi/8, 7*pi/8]; % Low pass filter.
%fz = [2*pi/5, 4*pi/5, 6*pi/5, 8*pi/5, 10*pi/5]; % All pass filter
%Rz = 0.1; % High pass filter
Rz = 1; % Low pass filter
%Rz = 1; % All pass filter
num = poly([Rz*exp(-fz*1i) Rz*exp(fz*1i)]);
z = roots(num);

% Poles:
%fp = [5*pi/8, 6*pi/8, 7*pi/8]; % High pass filter
fp = [3*pi/8, 2*pi/8, pi/8]; % Low pass filter
%fp = [2*pi/5, 4*pi/5, 6*pi/5, 8*pi/5, 10*pi/5]; % All pass filter
%Rp = 1; % High pass filter
Rp = 0.1; % Low pass filter
%Rp = 1; % All pass filter
den = poly([Rp*exp(-fp*1i) Rp*exp(fp*1i)]);
p = roots(den);

% Save numerator and denumerator for later use:
save(fullfile('filters', 'LowPassFilter.mat'), 'den', 'num', 'z', 'p')



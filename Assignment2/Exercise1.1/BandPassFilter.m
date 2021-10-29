close all; clear;

% Parameters:
Wp = [0.2, 0.3];
Ws = [0.1 0.4];
Rp = 2;
Rs = 100;

% Calculate coefficients for filter:
[n, Wn] = buttord(Wp, Ws, Rp, Rs);

[b, a] = butter(n, Wn, 'bandpass');

% Save coefficients:
save(fullfile('FilterCoefficients', 'bandpassCoefficients.mat'), 'b','a','n','Wn')
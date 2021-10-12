clear; close all;

% Chose filter type, LowPass, HighPass or AllPass:
filterType = 'AllPass';

% Load numerator and denumerator from filter:
data = load(fullfile('filters', [filterType 'Filter.mat']));
den = data.den;
num = data.num;

% Parameters for signal:
f0 = 50; % Fundamental frequency
fs = 41000; % Sampling frequency
A = 1; % Amplitude
T = 1; % Duration in seconds
timeVector = 0 : 1/fs : T - 1/fs; 

signal  = A * sin(2 * pi * f0 * timeVector);

% Filter sinusoid:
filteredSignal = filter(den, num,  signal);

plot(timeVector, filteredSignal)

% Save signal:
save(fullfile('signals', [filterType 'FilteredSignal.mat']), 'filteredSignal', 'signal', 'timeVector');
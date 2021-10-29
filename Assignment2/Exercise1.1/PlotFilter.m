close all; clear;

% Load coefficients:
filterData = load(fullfile('FilterCoefficients', 'bandpassCoefficients.mat'));
b = filterData.b;
a = filterData.a;
n = filterData.n;
Wn = filterData.Wn;

% Plot:
figure;
zplane(b, a), title('Poles and zeros');

figure;
freqz(b, a), title(sprintf('Frequency response, order: %d, corner frequencies: %f and %f ', n, Wn));

figure;
impz(b,a);
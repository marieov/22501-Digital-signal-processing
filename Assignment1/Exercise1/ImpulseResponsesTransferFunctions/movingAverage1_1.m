clear; close all;

% Order of filter:
N = 5;

% Create polynomial:
num = 1/(N+1)*ones(1, N+1);
den = 1;

% Find poles and zeros:
z = roots(num);
p = roots(den);

% Plot the poles and zeros:
figure()
zplane(z, p);
title(sprintf('Poles and zeros of moving average filter of order %d', N));

% Plot the frequency response:
figure();
freqz(num, den);
title(sprintf('Frequency response of moving average filter of order %d', N));
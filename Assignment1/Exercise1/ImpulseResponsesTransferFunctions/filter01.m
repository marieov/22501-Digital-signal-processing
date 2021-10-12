clear; close all;
% Frequency to attinuate:
f = 0.1 * pi;

% Radius of poles:
R = 0.99;

% Find coefficients for roots:
num = poly([exp(-f*1i) exp(f*1i) exp(-f*1i) exp(f*1i)]);
den = poly([R*exp(-f*1i) R*exp(f*1i) R*exp(-f*1i) R*exp(f*1i)]);

% Find poles and zeros:
z = roots(num);
p = roots(den);

% Plot of poles and zeros;
figure
zplane(z, p)
title(sprintf('Poles and zeros of filter attinuating frequency of %d', round(f, 3)));

% Frequency response:
figure
freqz(num, den);
title(sprintf('Frequency response of filter attinuating frequency of %d', round(f, 3)));
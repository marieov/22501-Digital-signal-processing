clear; close all;

% Load filtered and unfiltered signals:
LowPassData = load(fullfile('signals', 'LowPassFilteredSignal.mat'));
signal = LowPassData.signal;
LowPassFilteredSignal = LowPassData.filteredSignal;
timeVector = LowPassData.timeVector;

HighPassData = load(fullfile('signals', 'HighPassFilteredSignal.mat'));
HighPassFilteredSignal = HighPassData.filteredSignal;

AllPassData = load(fullfile('signals', 'AllPassFilteredSignal.mat'));
AllPassFilteredSignal = AllPassData.filteredSignal;

% Load filter data for plotting:
LowPassFilter = load(fullfile('filters', 'LowPassFilter.mat'));
HighPassFilter = load(fullfile('filters', 'HighPassFilter.mat'));
AllPassFilter = load(fullfile('filters', 'AllPassFilter.mat'));

% Plot poles and zeros:
subplot(3, 3, 1);
zplane(LowPassFilter.z, LowPassFilter.p);
title('Z and P of low pass filter')

subplot(3, 3, 2);
zplane(HighPassFilter.z, HighPassFilter.p);
title('Z and P of high pass filter')

subplot(3, 3, 3);
zplane(AllPassFilter.z, AllPassFilter.p);
title('Z and P of all pass filter')

% Plot frequeny response:
[hLow, wLow] = freqz(LowPassFilter.num, LowPassFilter.den);
subplot(3,3,4)
semilogy(wLow/pi, abs(hLow)), grid
ylim([10^-3, 10^3])
yticks([10^-2 10^-1 10^0 10^1,10^2])
title('Frequency response low pass', 'FontSize', 10)
ylabel('Magnitude [dB]')
xlabel('Normalized frequency', 'FontSize', 8)

[hHigh, wHigh] = freqz(HighPassFilter.num, HighPassFilter.den);
subplot(3,3,5)
semilogy(wHigh/pi, abs(hHigh)), grid
ylim([10^-4, 10^3])
yticks([10^-3 10^-2 10^-1 10^0 10^1 10^2])
title('Frequency response high pass', 'FontSize', 10)
ylabel('Magnitude [dB]')
xlabel('Normalized frequency', 'FontSize', 8)

[hAll, wAll] = freqz(AllPassFilter.num, AllPassFilter.den);
subplot(3,3,6)
semilogy(wAll/pi, abs(hAll)), grid
yticks([10^-3 10^-2 10^-1 10^0 10^1])
title('Frequency response all pass', 'FontSize', 10)
ylabel('Magnitude [dB]')
xlabel('Normalized frequency', 'FontSize', 8)


% Plot all signals;
subplot(3,2,6)
hold on 
plot(timeVector, signal);
plot(timeVector, LowPassFilteredSignal);
plot(timeVector, AllPassFilteredSignal);
plot(timeVector, HighPassFilteredSignal);
xlim([0, 0.07])
title('Sinusoid of 50 Hz and unit amplitude, filtered', 'FontSize', 11)
legend('Original', 'Low pass', 'All pass', 'High pass')
xlabel('Time [s]')
ylabel('Amplitude, a.u.')
hold off

subplot(3,2,5)
hold on 
plot(timeVector, signal);
plot(timeVector, LowPassFilteredSignal);
plot(timeVector, AllPassFilteredSignal);
xlim([0, 0.07])
title('Sinusoid of 50 Hz and unit amplitude, filtered', 'FontSize', 11)
xlabel('Time [s]')
ylabel('Amplitude, a.u.')
hold off
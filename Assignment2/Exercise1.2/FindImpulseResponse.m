close all; clear;

% The filter passes all frequencies between 0 and 5000 Hz with a gain of
% 0 dB. Thus we construct the frequency domain representation of the filter
% and transform it into time domain to get the impulse response. 

fs = 30000; % Since 1/3 of the normalized frequency is 5000 Hz.

Wp = 1/3; % Fraction of normalized frequencies that passes.

order = 600; % Since the order is the length of the impulse response minus 1.

% Construct the frequency domain filter:
Ypos = [zeros(1,floor((1-Wp) * order/2) +1) ones(1,floor(Wp*order/2))];
Yneg = fliplr(Ypos(1:end-1));

Y = [Ypos Yneg];
freq = -fs/2:fs/(order + 1):fs/2-fs/(order+1);

% Plot frequency domain filter:
figure;
stem(freq, Y);
ylim([-0.1, 1.1])
title("Frequency domain representation of my colleague's filter");
xlabel('Frequency [Hz]');
ylabel('Amplitude [a.u.]');


% Transform into time domain:
y = fft(ifftshift(Y));

% Shift the signal to make it suitable for time domain:
y = fftshift(y);
timeVector = 0:1/fs:order*1/fs;

% Plot impulse response:
figure;
plot(timeVector, y);
ylim([-50, 210])
title("Impulse response of my colleague's filter");
xlabel('Time [s]');
ylabel('Amplitude [a.u.]');

% Reduce impulse response and plot frequency responses:
h500 = freqz(y(1:500));
h400 = freqz(y(1:400));
h300 = freqz(y(1:300));
h200 = freqz(y(1:200));
h100 = freqz(y(1:100));

% Plot the frequency responses:
figure;
hold on;
plot(abs(h500));
plot(abs(h400));
plot(abs(h300));
plot(abs(h200));
plot(abs(h100));
legend('500 samples', '400 samples', '300 samples', '200 samples', '100 samples')
title('Frequency response of different lengths of the impulse response');
xlabel('Frequency [Hz]');
ylabel('Amplitude [a.u.]');
hold off;




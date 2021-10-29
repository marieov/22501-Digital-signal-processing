% Load data:
filterData = load(fullfile('FilterCoefficients', 'bandpassCoefficients'));

b = filterData.b;
a = filterData.a;

% Get the impulse response:
[h, t] = impz(b,a);

% Find efficient length:
percentage = 10;

idx = find(h > (percentage * max(h)/100), 1 , 'last');

%window = hann(floor(0.75 * idx));
window = rectwin(floor(0.75 * idx));
h75 = freqz(window .* h(1:floor(0.75 * idx)));

%window = hann(floor(0.6 * idx));
window = rectwin(floor(0.60 * idx));
h60 = freqz(window .* h(1:floor(0.6 * idx)));

%window = hann(floor(0.4 * idx));
window = rectwin(floor(0.40 * idx));
h40 = freqz(window .* h(1:floor(0.4 * idx)));

%window = hann(floor(0.1 * idx));
window = rectwin(floor(0.10 * idx));
h10 = freqz(window .* h(1:floor(0.1 * idx)));

% Plot:
figure;
hold on
plot(abs(h75))
plot(abs(h60))
plot(abs(h40))
plot(abs(h10))
title('Frequency responeses')
ylabel('Amplitude [a.u]')
xlabel('Frequency [Hz]')
legend('75% of efficient length', '60% of efficient length', '40% of efficient length', '10% of efficient length')
hold off


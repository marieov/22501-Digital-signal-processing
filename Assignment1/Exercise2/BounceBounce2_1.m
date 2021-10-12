clear; close all;

% Parameters:
fs = 44100; % Sampling frequency in Hz
alpha = 0.6; % Reflection attenuation
tau = 0.03; % Delay in seconds
delay_samples = fix(tau*fs); % Delay in samples

% Time vector:
t_ma = 1/fs:1/fs:0.2;


% Produce impulse response:
delta_input = [ones(1,1);zeros(length(t_ma)-1,1)];


% Numerator and denominator for FIR filter
num = [1;zeros(delay_samples,1);alpha];
den = [1;zeros(delay_samples+1,1)];

% Create the finite impulse response 
h_fir = filter(num,den,delta_input);

[h,f] = freqz(num,den,328,fs);

% Plotting:
figure(1)
subplot(3,1,1)
plot(t_ma,h_fir)
title('FIR impulse response')
xlabel('Time/s')
ylabel('Amplitude/a.u.')
xlim([0 0.05])

subplot(3,1,2)
plot(f,20*log10(abs(h)))
title('FIR frequency response')
xlabel('Frequency/Hz')
ylabel('Magnitude/dB')
xlim([0 7.35e3])

subplot(3,1,3)
plot(f,angle(h))
title('FIR phase response')
xlabel('Frequency/Hz')
ylabel('phase/radians')
xlim([0 7.35e3])


% Numerator and denominator for IIR filter
num_iir = den;
den_iir = num;

% Create infinite impulse response 
h_iir = filter(num_iir,den_iir,delta_input);

[h2,f2] = freqz(num_iir,den_iir,328,fs);

% Plotting:
figure(2)
subplot(3,1,1)
plot(t_ma,h_iir)
title('IIR impulse response')
xlabel('Time/s')
ylabel('Amplitude/a.u.')


subplot(3,1,2)
plot(f2,20*log10(abs(h2)))
title('IIR frequency response')
xlabel('Frequency/Hz')
ylabel('Magnitude/dB')
xlim([0 7.35e3])

subplot(3,1,3)
plot(f2,angle(h2))
title('IIR phase response')
xlabel('Frequency/Hz')
ylabel('phase/radians')
xlim([0 7.35e3])



% let's load a .wav file and convolve it with our IR!
[y, fs_y] = audioread(['C:', filesep, 'Users', filesep, 'liamg', filesep, 'OneDrive', filesep, 'Documents', filesep, 'DTU DSP 22051', filesep, 'sounds', filesep, 'mini-me_short.wav']);



% in case you'll load a stereo signal you might want to go MONO
y = y(:);       % we first make it column vectors
y = y(:,1);     % and then we only use the first column

% Now we need to see if the sampling frequencies match! If not, sample to
% the fs of the audio signal
if (fs~=fs_y)
    h_ir_resample = resample(h_iir, fs_y, fs);
    out = conv(h_ir_resample, y);
else
    out = conv(h_iir, y);
end
            
% Normalize the amplitude that you don't blow your ears
out = out/max(out)*.5;

% Filter the audio in the FIR and IIR filters
filtered_audio_fir = filter(num,den,y);
filtered_audio_iir = filter(num_iir,den_iir,y);

% Plotting the differences between unfiltered, FIR, and IIR
figure(3)
subplot(3,1,1)
plot(y)
title('Unfiltered mini-me audio')
xlabel('Time/s')
ylabel('Amplitude/a.u.')

subplot(3,1,2)
plot(filtered_audio_fir)
title('FIR mini-me audio')
xlabel('Time/s')
ylabel('Amplitude/a.u.')

subplot(3,1,3)
plot(filtered_audio_iir)
title('IIR mini-me audio')
xlabel('Time/s')
ylabel('Amplitude/a.u.')


%>> clear sound
%plays the sound of the FIR filter
%sound(out, fs_y)


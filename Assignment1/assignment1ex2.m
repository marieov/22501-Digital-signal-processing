clear all

%some of the parameters
fs = 44100; %sampling frequency in Hz
alpha = 0.6; %reflection attenuation
tau = 0.03; % delay in s
delay_samples = fix(tau*fs); % the delay in samples

%time vector to plot impulse response
t_ma = 1/fs:1/fs:1;


%produces an impulse at zero
delta_input = [ones(1,1);zeros(length(t_ma)-1,1)];


%the numerator and denominator for the FIR filter
num = [1;zeros(delay_samples,1);alpha];
den = [1;zeros(delay_samples+1,1)];

%creates the finite impulse response 
h_fir = filter(num,den,delta_input);

[h,f] = freqz(num,den,328,fs);

%plotting the results for the FIR filter
figure(1)
subplot(3,1,1)
plot(t_ma,h_fir)
title('FIR impulse response')
xlabel('Time/s')
ylabel('Amplitude')

subplot(3,1,2)
plot(f,20*log10(abs(h)))
title('FIR frequency response')
xlabel('Frequency/Hz')
ylabel('Magnitude/dB')

subplot(3,1,3)
plot(f,angle(h))
title('FIR phase response')
xlabel('Frequency/Hz')
ylabel('phase/radians')


%the numerator and denominator for the IIR filter
num_iir = den;
den_iir = num;

%creates the infinite impulse response 
h_iir = filter(num_iir,den_iir,delta_input);

[h2,f2] = freqz(num_iir,den_iir,328,fs);

%plotting the results of the IIR filter
figure(2)
subplot(3,1,1)
plot(t_ma,h_iir)
title('IIR impulse response')
xlabel('Time/s')
ylabel('Amplitude')

subplot(3,1,2)
plot(f2,20*log10(abs(h2)))
title('IIR frequency response')
xlabel('Frequency/Hz')
ylabel('Magnitude/dB')

subplot(3,1,3)
plot(f2,angle(h2))
title('IIR phase response')
xlabel('Frequency/Hz')
ylabel('phase/radians')



% let's load a .wav file and convolve it with our IR!
[y, fs_y] = audioread(['C:', filesep, 'Users', filesep, 'liamg', filesep, 'OneDrive', filesep, 'Documents', filesep, 'DTU DSP 22051', filesep, 'sounds', filesep, 'mini-me_short.wav']);



% in case you'll load a stereo signal you might want to go MONO
y = y(:);       % we fist make it column vectors
y = y(:,1);     % and then we only use the first column

% Now we need to see if the sampling frequencies match! If not, sample to
% the fs of the audio signal
if (fs~=fs_y)
    h_ir_resample = resample(h_iir, fs_y, fs);
    out = conv(h_ir_resample, y);
else
    out = conv(h_iir, y);
end
            
% normalize the amplitude that you don't blow your ears
out = out/max(out)*.5;

%filtering the audio in the FIR and IIR filters
filtered_audio_fir = filter(num,den,y);
filtered_audio_iir = filter(num_iir,den_iir,y);

%plotting the differences between unfiltered, FIR, and IIR
figure(3)
subplot(3,1,1)
plot(y)
title('Unfiltered mini-me audio')
xlabel('Time/s')
ylabel('Amplitude')

subplot(3,1,2)
plot(filtered_audio_fir)
title('FIR mini-me audio')
xlabel('Time/s')
ylabel('Amplitude')

subplot(3,1,3)
plot(filtered_audio_iir)
title('IIR mini-me audio')
xlabel('Time/s')
ylabel('Amplitude')


%>> clear sound
%plays the sound of the FIR filter
%sound(out, fs_y)


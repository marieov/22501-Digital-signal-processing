function [FIR_coefs] =  FIR_Filter_coef (wc1,wc2, Gain ,filter_length )
% FIR_Filter_coef  Summary of this function : 
% compute the FIR filter , transfer function coefs ( which are basically the
% impulse response components )

%   Detailed explanation 
% output of the function :
%FIR_coefs : components of the impulse response  
% Input parameters of the function :
%wc1 : first border of the band pass ( normalized fromat : 0<wc1<pi)
%wc2 : second border of the band pass (normalized format : wc1<wc2<pi )
%Gain : the amplitude of pass band region given in dB ( but needs to be
%converted to the linear amplitude for matlab purpose !)
%filter_length : it's the order of filter +1 



% Let's start creating the causal region of the frequency response 

fs =  2/ filter_length ; % sampling frequency in the normalized frequency scale

normalized_right_freq_vector = 0:fs:1-fs ; 
normalized_left_freq_vector = -1:fs:0-fs ; 
special_freq_vector = [ normalized_right_freq_vector , normalized_left_freq_vector] ;
normalized_freq_vector = -1:fs:1-fs ; 

% conversion of gain from dB to linear 
g = exp( (Gain * log10(10)) / 20 ) ; 

if mod(filter_length ,2 ) == 0 
    length_ = filter_length / 2 ; 
else 
    length_ = (filter_length+1)/2 ; 
end

freq_response = ones(1,length_ ) ;

for i=1:length(normalized_right_freq_vector)
    if (normalized_right_freq_vector(i) < wc1 ) | (normalized_right_freq_vector(i) > wc2)
        freq_response(i) = g; 
    end
end

%  we use the right part of the frequency response to create the entire
%  frequency response vector in Matlab desired format 

% negative part

freq_response_ = fliplr(freq_response) ; 

if mod(filter_length ,2 ) == 0 
    freq_response = [ freq_response ,  freq_response_ ] ; 
else 
    freq_response = [freq_response , freq_response_(2:end)] ; 
end


% the frequency response in the desired Matlab format 
figure()
subplot(3,1,1)
plot( special_freq_vector, 20*log10(abs(freq_response))) ; 
title(' Filter frequeny response in the Matlab format')
xlabel('Normalized frequencies a.u ')
ylabel('Magnitude in dB ')

 
impulse_response = ifft(freq_response ); 

% to see if we need to fft shift or not 

subplot(3,1,2)
plot( real(impulse_response) ) ; 
title(' Impulse response of the filter before fftshift ')
xlabel('Time in s ')
ylabel('Magnitude a.u')
xlim([1 5])

impulse_response = fftshift(impulse_response);
FIR_coefs = impulse_response ; 

subplot(3,1,3)
plot( abs((impulse_response)) ) ; 
title(' Impulse response of the FIR filter after FFT shift ')
xlabel('Time in s ')
ylabel('Magnitude a.u')
xlim([147 155])

% To verify if the impulse_response length is as expected equel to the
% filter order + 1 
 
if length(impulse_response) == filter_length 
    disp('correct impulse response size ! ')
else
    disp('incorrect impulse response size ! ')
end

% plotting the immaginary part of the impulse response to check that is
% small

figure()
plot( abs(imag(impulse_response)) ) ; 
title(' Magnitude of Imag part of impulse response ')
xlabel('Time in s ')
ylabel('Magnitude a.u')
ylim([0 10e-3])
xlim([0 50])

% the windowing step : we will cut the impulse response to 90% of it's
% maximal power ( effective length ) as done in the previous exercice

effective_length = 0 ;
Max_amplitude = max(abs(impulse_response)) ;
threshold_amplitude = 0.1 * Max_amplitude ; 
 
for i=1:length(impulse_response)
    if abs(impulse_response(i)) > threshold_amplitude
        effective_length = i ; 
    end
end

effective_length

% create the Hamming window and Hann window 
Hamming_window = hamming(effective_length);
Hann_window = hann(effective_length) ;


%Hamming_window = hamming(length(impulse_response));
%Hann_window = hann(length(impulse_response)) ;



Hamming_window = zero_padded(Hamming_window ,length( impulse_response)) ; 
Hann_window  = zero_padded(Hann_window, length(impulse_response)) ;

% plotting the Hann and Hamming windows 

figure()
subplot(1,2,1)
plot(Hamming_window)
title('Hamming window')
subplot(1,2,2)
plot(Hann_window)
title('Hann window')


% Apply the windows to the impulse_response 

% without zero padding 

%Hamming_impulse_response = impulse_response .* transpose(Hamming_window)
%Hann_impulse_response = impulse_response .* transpose(Hann_window) 

% with zero padding 
Hamming_impulse_response = impulse_response .* Hamming_window ;
Hann_impulse_response = impulse_response .* Hann_window  ;


Hamming_freq_response= fft(Hamming_impulse_response);
Hann_freq_response = fft(Hann_impulse_response);

% plot the frequency response of the windowed impulse responses 
figure()
subplot(3,1,1)
plot(normalized_freq_vector , 20*log10(abs(freq_response)) ,'color','r')
title(' Original FIR frequeny responses before windowing ')
xlabel('Normalized Frequency a.u')
ylabel('Magnitude (dB)')
xlim([0 1])


subplot(3,1,2)
plot( normalized_freq_vector ,20*log10(abs(Hamming_freq_response)),'color' ,'b')
title(' Frequeny response of the filter after Hamming windowig it s FIR  ')
xlabel('Normalized Frequency a.u')
ylabel('Magnitude (dB)')
xlim([0 1])

subplot(3,1,3)
plot(normalized_freq_vector ,20*log10(abs(Hann_freq_response)),'color','g')
title(' Frequeny response of the filter after Hann windowig it s FIR  ')
xlabel('Normalized Frequency a.u')
ylabel('Magnitude (dB)')
xlim([0 1])

figure()
plot(normalized_freq_vector , 20*log10(abs(freq_response)) ,'color','r')
hold on 
plot( normalized_freq_vector ,20*log10(abs(Hamming_freq_response)),'color' ,'b')
plot(normalized_freq_vector ,20*log10(abs(Hann_freq_response)),'color','g')
xlabel('Normalized Frequency a.u')
ylabel('Magnitude (dB)')
legend('FR before windowing ','FR of the Hamming windowed FIR ' ,'FR of the Hann windowed FIR ')
xlim([0 1])


% filtering mini me.wav of Hands_on 7 with the designed windowed filters

fname2 ='sig2.wav' ;
% extract the sounds 
[x , fs] = audioread(fname2);


filtred_x = filter(abs(impulse_response),1,x) ;
filtred_x_Hamming_window =filter(abs(Hamming_impulse_response),1,x);
filtred_x_Hann_window = filter(abs(Hann_impulse_response),1,x);


T = 5 ; % time duration of the signal
t = 0:1/fs:T-(1/fs); %time vector

figure()

subplot(4,1,1)
plot(t,x)
title('  time domain representation of the input signal before filtration')
xlabel('time in s ')
ylabel('Magnitude a.u.')
xlim([0 0.5]) 

subplot(4,1,2)
plot(t,filtred_x)
title('  input signal filtred with the non windowed FIR')
xlabel('time in s ')
ylabel('Magnitude a.u.')
xlim([0 0.5]) 

subplot(4,1,3)
plot(t,filtred_x_Hamming_window)
title(' input signal filtred with the Hamming windowed FIR')
xlabel('time in s ')
ylabel('Magnitude a.u.')
xlim([0 0.5]) 

subplot(4,1,4)
plot(t,filtred_x_Hann_window)
title(' input signal filtred with the Hann windowed FIR ')
xlabel('time in s ')
ylabel('Magnitude a.u.')
xlim([0 0.5]) 

% listen to the scrabled eggs before filtring  
%sound( x, fs)

% listen to the filtred scrabled eggs 
%sound( filtred_x, fs)
%sound( filtred_x_Hamming_window, fs)
%sound( filtred_x_Hann_window, fs)


end


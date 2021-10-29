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
%Gain : the amplitude of pass band region given in dB ( but needsz to be
%converted to the linear amplitude for matlab purpose !)
%filter_length : it's the order of filter +1 



% Let's start by creation the causal region of the frequency response 

fs =  2 / filter_length ; % sampling frequency in the normalized frequency scale

normalized_right_freq_vector = 0:fs:1-fs ; 
normalized_left_freq_vector = -1:fs:0-fs ; 
special_freq_vector = [ normalized_right_freq_vector , normalized_left_freq_vector]
normalized_freq_vector = -1:fs:1-fs ; 

% conversion of gain from dB to linear 
g = exp( (Gain * log10(10)) / 20 ) ; 

if mod(filter_length ,2 ) == 0 
    length_ = filter_length / 2 ; 
else 
    length_ = (filter_length+1)/2 ; 
end


freq_response = g*ones(1,length_ ) ;


for i=1:length(normalized_right_freq_vector)
    if (normalized_right_freq_vector(i) < wc1 ) | (normalized_right_freq_vector(i) > wc2)
        freq_response(i) = 1; 
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


figure()
plot( special_freq_vector,abs(freq_response)) ; 
title([' Magnitude of frequeny response ']);
xlabel('Positive than negative frequencies ')
ylabel('Magnitude in dB ')

% plotting the immaginary part of the impulse response to check that is
% small 

impulse_response = ifft(freq_response ); 

figure()
plot( abs(imag(impulse_response)) ) ; 
title([' Magnitude of Imag part of impulse response ']);
xlabel('Time in s ')
ylabel('Magnitude a.u')

% To verify if the impulse_response length is as expected equel to the
% filter order + 1 
 
if length(impulse_response) == filter_length 
    disp('correct impulse response size ! ')
else
    disp('incorrect impulse response size ! ')
end

% to see if we need to fft shift or not 
figure()
plot( abs((impulse_response)) ) ; 
title([' Impulse response of the FIR filter ']);
xlabel('Time in s ')
ylabel('Magnitude a.u')

impulse_response = fftshift(impulse_response);
FIR_coefs = impulse_response ; 

figure()
plot( abs((impulse_response)) ) ; 
title([' Impulse response of the FIR filter after FFT shift ']);
xlabel('Time in s ')
ylabel('Magnitude a.u')



Max_amplitude = max(abs(impulse_response)) ;
threshold_amplitude = 0.1 * Max_amplitude ; 
effective_length = 0 ; 
for i=1:length(impulse_response)
    if abs(impulse_response(i)) > threshold_amplitude
        effective_length = i ; 
    end
end

% create the Hamming window and Hann window 
Hamming_window = hamming(effective_length);
Hann_window = hann(effective_length) ;

figure()
plot(Hamming_window)
hold on 
plot(Hann_window)
% Apply the windows to the impulse_response 

Hamming_impulse_response = impulse_response .* Hamming_window ;
Hann_impulse_response = impulse_response .* Hann_window ;

Hamming_freq_response= fft(Hamming_impulse_response);
Hann_freq_response = fft(Hann_impulse_response);

%Hamming_freq_response = zero_padded(Hamming_freq_response ,length( normalized_freq_vector)) ; 
%Hann_freq_response  = zero_padded(Hann_freq_response , length(normalized_freq_vector)) ;

% plot the frequency response of the windowed impulse responses 
figure()
plot(abs(freq_response) ,'color','red') 
hold on 
plot( abs(Hamming_freq_response),'color' ,'blue')
plot( abs(Hann_freq_response),'color','green')
title([' Original vs Hann and Hamming windowed FIR frequeny responses ']);
legend('original IR ','Hamming windowed IR' , 'Hann windowed IR')
xlabel('Normalized Frequency (\times\pi rad/sample)')
ylabel('Magnitude (dB)')
xlim([0 100])




end


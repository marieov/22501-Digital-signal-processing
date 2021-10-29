function [Y, freq] = make_spectrum(signal, fs)
% Here goes the help message : returns the complex vector of the FFT of
% given signal and it's frequency vector
% We need to plot the spectra in time , give the real and immaginary part ,
% plot if it makes sense the phase spectrum
% For acoutisal signal the amplitude needs to be converted in DB via
%signal_dB = 20*log10(abs(vector_with_spectrum));

...% compute spectrum (note: it will be complex-valued)
Y = fft(signal);
Y = fftshift(Y);
% The FFT needs to be scaled in order to give a physically plausible scaling.
Y = Y/(length(Y));
% NOTE: If you do an IFFT, this scaling must NOT be done.
% We'll get to this in the lecture. If you are only interested
% in the positive frequencies, you need to scale by <length(Y)/2>.
% frequency vectordelta_f = ...freq = 0:
delta_f = fs / (length(Y)) ;
freq_pos = 0:delta_f: (fs/2)-delta_f ; 
freq_neg = -fs/2: delta_f:-delta_f
% NOTE: The first element that comes out of the FFT is the DC offset% (i.e., frequency 0). Each subsequent
% bin is spaced by the frequency resolution <delta_f> which you can% calculate from the properties of the inut signal. Remember the highest
% frequency you can get in a digitized signal...
% ...% convert into column vector (if required)
freq =[freq_neg freq_pos] ;
Y = Y(:);
freq = freq(:);
% eofend


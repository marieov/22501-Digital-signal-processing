function [zero_padded] = zero_padded(input_signal,final_size)
% adds zeros to the input_signal given to reach the final size given
% Good practice for point wise multiplication of Fourier trasnforms 
zero_padded = zeros(1,final_size);
for i =1:final_size
    if i <= length(input_signal)
        zero_padded(i) = input_signal(i);
    else
        zero_padded(i) = 0 ;
    end
    
end

end


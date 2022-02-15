function filt_signal = filter_w_bank(filt_bank, input_signal)
% FILTER_W_BANK Filters the signal using a predefined bank of filters,
% previously generated using the function IIR_FILTER_BANK
% Input parameters:
%   filt_bank - cell representing the specified filter bank
%   input_signal - signal to be filtered
%
% Output parameters:
%   filt_signal - filtered signal

filt_signal = zeros(size(input_signal));
for i = 1:length(filt_bank)
    filt_signal = filt_signal + filter(filt_bank{i}, input_signal);
end
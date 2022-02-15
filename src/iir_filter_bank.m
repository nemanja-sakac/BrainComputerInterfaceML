function bank = iir_filter_bank(pb_val, tran_val, central_freq,...
        pb_ripple, sb_atten, filt_type, fs)
% IIR_FILTER_BANK Generates a cell of simetric IIR bandpass 
% filters representing a filter bank.
%
% Input parameters:
%   PB_VAL - half width value of the filter bandwidth.
%       Left and right bounds from the central frequencies of the filters 
%       will be defined according to this value
%       pf1 = central_freq - pb_val
%       pf2 = central_freq + pb_val
%   TRAN_VAL - transition band of the filter
%   CENTRAL_FREQ - central frequencies of the filter bank
%   PB_RIPPLE - passband ripple in dB
%   SB_ATTEN - stopband attenuation in dB
%   FILT_TYPE - filter type
%   FS - signal sampling frequency
%
% Output parameters:
%   bank - filter bank

% Left passband frequency bound
pf1 = central_freq - pb_val;
% Right passband frequency bound
pf2 = central_freq + pb_val;
% Left stopband frequency bound
sbf1 = pf1 - tran_val;
% Right stopband frequency bound
sbf2 = pf2 + tran_val;
% Specified number of filters dependent on the central_freq vector
n_filts = length(central_freq);

bank = cell(1, n_filts);
for i = 1:n_filts
    bank{i} = designfilt('bandpassiir',...
        'StopbandFrequency1', sbf1(i),...
        'PassbandFrequency1', pf1(i),...
        'PassbandFrequency2', pf2(i),...
        'StopbandFrequency2', sbf2(i),...
        'StopbandAttenuation1', sb_atten,...
        'PassbandRipple', pb_ripple,...
        'StopbandAttenuation2', sb_atten,...
        'SampleRate', fs,...
        'DesignMethod', filt_type);
end

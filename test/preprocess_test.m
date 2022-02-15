%%
% Load subjects
load('../bin/subjects_exp3.mat')
addpath('../src');
addpath('../bin');

%%
% Filter transfer function - Elliptical Bandpass IIR filter for the
% extraction of the desired bandwidth (6-48 Hz)

% Filter specifications
% Sampling frequency - 250 Hz
fs = 250;
% Passband = [5 Hz, 48 Hz]
% Stopband = [4 Hz, 49 Hz]
% Passband ripple = 1 dB
% Stopband attenuation(1, 2) = 60 dB
filt_object = designfilt('bandpassiir',...
    'StopbandFrequency1', 5,...
    'PassbandFrequency1', 6,...
    'PassbandFrequency2', 48,...
    'StopbandFrequency2', 49,...
    'StopbandAttenuation1', 60,...
    'PassbandRipple', 1,...
    'StopbandAttenuation2', 60,...
    'SampleRate', fs,...
    'DesignMethod', 'ellip');

% Plot the amplitude spectrum of the desired filter
% fvtool(filt_object)

%%
% Generating a bank filters - another approach
% Specification
% Bandwidth = 0.5 Hz from the central frequency
pb_val = 0.25;
% Transitory bandwidth = 0.5 Hz
tran_val = 0.25;
% Passband ripple = 1 dB
pb_ripple = 1;
% Stopband attenuation = 40 dB
sb_atten = 60;
% Central frequencies = (6.67, 7.50, 8.57, 10.00, 12.00)
central_freq = [6.67, 7.50, 8.57, 10.00, 12.00];
% Filter type - Elliptical
filt_type = 'ellip';
filter_bank = iir_filter_bank(pb_val, tran_val, central_freq,...
        pb_ripple, sb_atten, filt_type, fs);

%%
% Parameter specifications of the Welch spectrum
% Lowest frequency expected in the signal lies at 5 Hz
f_min = 5;
% For a good frequency resolution of the spectrum window, the window should 
% encompass at least two periods of the lowest frequency of the signal
f_window = f_min / 2;
T_window = 1 / f_window;
% Round the sample number of the window so it's a multiple of two
window_width = T_window * fs;
multiple_of_two = ceil(log2(window_width));
% Window size 4 times larger than the minimum window size expected results
% in a better frequency resolution
window_width = 2 ^ multiple_of_two * 4;
% Window overlap
proc_overlap = 0.75;
% Number of samples overlapping
n_overlap = round(window_width * proc_overlap);
% Number of samples for the calculation of FFT
% Arbitrary, as long as nfft >= window_width
nfft = 1024;

%%
% Subject number (for testing)
i = 1;
% Subject number (for testing)
j = 1;
subject = subjects{i};

filt_signal = subject{i, j};
% Time axis
t = 0:1/fs:size(filt_signal, 1)/fs - 1/fs;
% Plot signal before filtering
plot(t, filt_signal(:, 1));

%%
% Filter signal with IIR filter
filt_signal = filter(filt_object, filt_signal);
% Plot signal after filtering
plot(filt_signal);

%%
% CAR artefact removal method
filt_signal = car(filt_signal);    
% Plot signal after the application of CAR
plot(t, filt_signal);
% hold on

%%
% Artefact removal using the AMUSE method
% AMUSE function expects columns as samples and rows as channels
% W - mixing matrix
[W, ~, extracted_signal] = amuse(filt_signal');
% Plot extracted components before their removal
figure
plot(extracted_signal')

%%
% Oscillatory component of exponential nature present
for_removal = [15];
% Plot the component
figure
plot(extracted_signal(for_removal, :))

%%
% Memory reservation
extracted_signal(for_removal, :) = zeros(length(for_removal), size(extracted_signal, 2));
% Project the signal back to the original space
filt_signal = (inv(W' * W) * W' * extracted_signal)';
% Plot the signal after the removal of unwanted components
figure
plot(filt_signal)

%%
% Signal filtering using a bank of filters
filt_signal = filter_w_bank(filter_bank, filt_signal);

%%
% Welch spectrum estimation(PDS - Power Density Spectrum)
[Pxx, F] = pwelch(filt_signal, window_width, n_overlap, nfft, fs);
% Plot the spectrum
plot(F, Pxx)

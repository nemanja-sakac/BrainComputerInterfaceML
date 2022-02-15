function prep_subjects = preprocess(subjects)
% PREPROCESS Preprocesses subject trials. First filters the trials with IIR 
% elliptical BP filters. After that AMUSE (Algorithm for Multiple Unknown 
% Signals Extraction) is used for the extraction of signals into components
% Unwanted components are removed.

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

prep_subjects = cell(1, length(subjects));
for i = 1:length(subjects)
    subject = subjects{i};
    for j = 1:size(subject, 2)
        filt_signal = subject{1, j};
        
        %----------
        % Time axis (for plotting)
        t = 0:1/fs:size(filt_signal, 1)/fs - 1/fs;

        % Plot signal before filtering
%         figure
%         plot(t, filt_signal)
%         xlabel('t(s)')
%         title('y(t) Before Filtering')
        
        % Plot first channel before filtering
%         figure
%         plot(t, filt_signal(:, 1))
%         xlabel('t(s)')
%         title('y(t) First Channel Before Filtering')
        %----------
        
        % Filter signal
        filt_signal = filter(filt_object, filt_signal);
        
        %----------
        % Plot signal after filtering
%         figure
%         plot(t, filt_signal)
%         xlabel('t(s)')
%         title('y(t) After Filtering')
        %----------

        % Artefact removal using the AMUSE method
        % AMUSE function expects columns as samples and rows as channels
        % W - mixing matrix
        [W, ~, extracted_signal] = amuse(filt_signal');
        
        %----------
        % Plot extracted components before removal
%         figure
%         plot(t, y')
%         xlabel('t(s)')
%         title('s(t) After Using AMUSE')
        
%         % Plot the first component before removal
%         figure
%         plot(t, y(1, :)');
%         xlabel('t(s)');
%         title('s(t) First Component');
        %----------
        
        % % Oscillatory component of exponential nature present
        for_removal = [1];
        extracted_signal(for_removal, :) = zeros(length(for_removal), size(extracted_signal, 2));
        % Project the signal back to the original space
        filt_signal = (inv(W' * W) * W' * extracted_signal)';
        
        %----------
        % Plot the signal after removing unwanted components
%         figure
%         plot(t, filt_signal);
%         xlabel('t(s)');
%         title('y(t) After Removing the First Component');
        %----------
        
        % Place preprocessed signals into cells
        prep_subjects{i}{1, j} = filt_signal;
        prep_subjects{i}{2, j} = subject{2, j};
    end
end

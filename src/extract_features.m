function features = extract_features(subjects, harmonics_str, en_type,...
        dir_name)
% EXTRACT_FEATURES(SUBJECTS, HARMONICS_STR, EN_TYPE, DIR_NAME) Extracts 
% features from a cell of preprocessed signals coming from SUBJECTS.
%
% Preprocessed trials are the function's inputs. Features are extracted
% from the Welch Power Density Spectrum. Samples are obtained from the
% spectrum around the central frequencies (6.67 Hz, 7.50 Hz, 8.57 Hz, 
% 10.00 Hz, 12.00 Hz). Samples are obtained around the frequencies of their 
% harmonics (up to the fourth harmonic) if the argument value 'harmonics'
% is passed to HARMONICS_STR. The samples are used for the estimation of 
% relative power density with regards to the whole spectrum, per each 
% channel.
%
% The resulting matrix of features is placed in a file specified by the
% DIR_NAME argument.


% Setting the parameters for the estimation the Welch Power Density
% Spectrum
% Sampling frequency
fs = 250;
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
% Frekvencijska rezolucija spektra
f_res = fs / nfft;

%%
% If 'harmonics' is passed as an argument value, energy is calculated with
% regards to harmonics
if strcmp(harmonics_str, 'harmonics')...
        || strcmp(harmonics_str, 'harmonics_sep')
    harmonics = 1:4;
elseif strcmp(harmonics_str, 'no_harmonics')
    harmonics = 1;
else
    harmonics = 1;
end

%%
% Central frequencies around which relative energies are calculated
central_freq = [6.67, 7.50, 8.57, 10.00, 12.00];
% Central frequency harmonics (up to the fourth harmonic)
% Rows correspond to central frequencies with their harmonics
multiples_freq = central_freq' * harmonics;

%%
% Each harmonic corresponds to some features
if strcmp(harmonics_str, 'harmonics_sep')
    multiples_freq = multiples_freq(:);
end

%%
% Cells with features
features = cell(1, length(subjects));
for i = 1:length(subjects)
    subject = subjects{i};
    for j = 1:size(subject, 2)
        % Trial extraction
        signal = subject{1, j};
        
        % Welch Power Density Spectrum estimation
        [Pxx, F] = pwelch(signal, window_width, n_overlap, nfft, fs);
        
        %----------
        % Plot the spectrum
%         figure
%         plot(F, Pxx)
%         xlabel('f(Hz)');
%         title('PDS without AMUSE');
        %----------
        
        % Relative energy estimation from the spectrum
        extracted_energy = extract_energy(Pxx, F, multiples_freq, f_res,...
            en_type);
        
        % Extracted energies without averaging
        % features{i}{1, j} = extracted_en;
        % IZBORNO
        % ----------
        % Mean energy across electrodes
        features{i}{1, j} = mean(extracted_energy);
        
        % Variance of energies across electrodes
        extracted_var = var(extracted_energy);
        % ----------
        
        % Signal entropy estimation
        % Channels correspond to rows in the input matrix
        extracted_entropy = extract_entropy(Pxx');

        % Matrix of features
        features{i}{1, j} = [features{i}{1, j},...
            extracted_var,...
            extracted_entropy];
        
        % Lables
        features{i}{2, j} = subject{2, j};
    end
end

% Save the feature matrix
save_feat_matrix(features, en_type, harmonics_str, dir_name)

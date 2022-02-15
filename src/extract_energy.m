function total_energy = extract_energy(Pxx, F, multiples_freq, f_res, en_type)
% EXTRACT_EN(PXX, F, MULTIPLES_FREQ, F_RES, EN_TYPE) Extracts relative 
% energies from the Welch Power Density Spectrum, PXX, of the signal.
%
% Energy type, EN_TYPE can be specified as:
%   'snr' - signal-to-noise ratio
%   'rel' - normalized relative energy with regards to the whole spectrum
% 

% Matrix of frequency indices from the spectrum closest to the selected
% central frequencies
% Harmonics by columns
ind_freq = zeros(size(multiples_freq));

% Number of samples around the central frequencies specified for the
% estimation of relative energy values
n_samples = ceil(0.5 / f_res);

% Marking frequency indices closest to the specified
for i = 1:size(ind_freq, 1)
    for j = 1:size(ind_freq, 2)
        [~, min_ind] = min(abs(multiples_freq(i, j) - F));
        ind_freq(i, j) = min_ind;
    end
end

% Indices of the left and right frequency bounds for energy estimation
left_ind = ind_freq - n_samples;
right_ind = ind_freq + n_samples;

if strcmp(en_type, 'rel')
    % Energy normalization
    total_en = sum(Pxx);
    norm_pxx = zeros(size(Pxx));
    for i = 1:length(total_en)
        norm_pxx(:, i) = Pxx(:, i) / total_en(i);
    end
elseif strcmp(en_type, 'snr')
    % Default method
    norm_pxx = Pxx;
end

% Energy extraction
% Number of samples around the frequencies of interest
n_freq_samples = 2 * n_samples - 1;
% Rows correspond to channels and columns to frequencies
total_energy = zeros(size(norm_pxx, 2), size(multiples_freq, 1));
% Channels
for k = 1:size(total_energy, 1)
    % Central frequencies
    for i = 1:size(total_energy, 2)
        % Harmonics
        for j = 1:size(multiples_freq, 2)
            % Total energy
            if strcmp(en_type, 'rel')
                total_energy(k, i) = total_energy(k, i)...
                    + sum(norm_pxx(left_ind(i, j):right_ind(i, j), k));
            elseif strcmp(en_type, 'snr')
                % Default 
                % calculated according to the SNR formula:
                % 10log(n * P(f_k) / sum(P(f_k - m * f_res) - P(f_k + m * f_res)))
                % Sum in the denominator corresponds to the sum of samples
                % in the area around the central frequency
                
                total_energy(k, i) = 10 * log10(n_samples * norm_pxx(ind_freq(i))...
                    / sum(norm_pxx(left_ind(i, j):right_ind(i, j), k)));
            end
        end
    end
end

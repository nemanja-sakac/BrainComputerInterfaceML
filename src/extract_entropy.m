function extracted_entropy = extract_entropy(Pxx)
% EXTRACT_ENTROPY(PXX) Extracts entropy from the Power Density Spectrum,
% PXX

% Average across channels
mean_channel_psd = mean(Pxx);

% Density distribution (scaling)
p_est = mean_channel_psd / sum(mean_channel_psd);

% Calculate information entropy
extracted_entropy = -sum(p_est * log(p_est)');
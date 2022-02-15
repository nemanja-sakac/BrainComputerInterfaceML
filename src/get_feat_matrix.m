function [feat_matrix, trial_label] = get_feat_matrix(subjects, n_trials)
% GET_FEAT_MATRIX Extracts features from subject trials into a matrix

% Number of features
n_feats = numel(subjects{1}{1, 1});
% Trial labels
trial_label = [];
% Feature matrix
feat_matrix = zeros(n_trials, n_feats);
ind_mat = 1;
for i = 1:length(subjects)
    for j = 1:size(subjects{i}, 2)
        feat_matrix(ind_mat, :) = subjects{i}{1, j}(:);
        trial_label = [trial_label; subjects{i}{2, j}];
        ind_mat = ind_mat + 1;
    end
end
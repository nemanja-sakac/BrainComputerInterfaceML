function [subject_id, n_trials] = vectorize_subj_id(subjects)
% VECTORIZE_SUBJ_ID(SUBJECTS) Returns a vector of subject IDs based on
% their trials.

% Vector of subject IDs for each channel
subject_id = [];
% Total number of trials
n_trials = 0;
for i = 1:length(subjects)
    n_trial_per_subj = size(subjects{i}, 2);
    n_trials = n_trials + size(n_trial_per_subj, 2);
    subject_id = [subject_id, i * ones(1, n_trial_per_subj)];
end
subject_id = subject_id';
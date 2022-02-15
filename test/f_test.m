%%
% Script for EEG signal preprocessing and feature extraction
%%
clear
clc
addpath('../src');
addpath('../bin');
addpath('../data');

%%
% Extract the subjects of the selected experiment
experiment_no = 3;
extract_subjects(experiment_no);

%%
% Load extracted subjects
load('../bin/subjects_exp3.mat')

%%
% Load EEG electrodes of interest
% For experiment 1 - O1 = 116, Oz = 126, O2 = 150
electrodes = [2, 4, 13];
for i = 1:length(subjects)
    for j = 1:size(subjects{i}, 2)
        subjects{i}{1, j} = subjects{i}{1, j}(:, electrodes);
    end
end

%%
% Subjects - 3 electrodes
save('../bin/subjects_3_electrodes.mat', 'subjects');

%%
% Load subjects with selected electrodes
load('../bin/subjects_3_electrodes.mat')

%%
% Preprocessing
prep_subjects = preprocess(subjects);

%%
% Example of a preprocessed resulting signal
plot(prep_subjects{1}{1, 1})

%%
% Feature extraction for subjects

% Select harmonic extraction parameter
% harmonics = 'harmonics';
harmonics = 'no_harmonics';
% harmonics = 'harmonics_sep';

% Extract features, subject IDs and labels into separate matrices
% Energy "type" to be extracted from the frequency spectrum
en_type = 'rel';

%%
% Directory for saving
% dir_name = '../bin/feats_rel_harm_entr.csv';
dir_name = '../bin/feats_rel_noharm_entr.csv';
% dir_name = '../bin/feats_rel_harmsep_entr.csv';

subjects_mat = extract_features(prep_subjects, harmonics, en_type, dir_name);

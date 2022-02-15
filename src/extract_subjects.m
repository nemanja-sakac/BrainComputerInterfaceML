function extract_subjects(n_experiment)
% EXTRACT_SUBJECTS(N_EXPERIMENT) The function extracts subjects into a cell
% data structure, with accordance to the defined number of experiments.
% Subjects are described by trials and their matching labels.
% Input parameters:
% 	N_EXPERIMENT - database (experiment) which is being loaded (takes
% 	values between 1 and 3)

session_no = eegtoolkit.util.Session;
% Load database matching the input experiment number n_experiment
session_no.loadAll(n_experiment);

% Extract index matching trials for each subject separately 
% e.g. all trials up to 126 belong to subject 1
[~, subject_index, ~] = unique(session_no.subjectids, 'first');
subject_index = [subject_index', length(session_no.trials) + 1];

% Indexes matching the beginning of each section
% session_indexes = [1, (find(diff(session_no.sessionids)) + 1)];

% Extract each subject
subjects = cell(1, length(subject_index) - 1);
for i = 1:length(subject_index) - 1
    subject = session_no.trials(subject_index(i):(subject_index(i+1) - 1));
    subjects{1, i} = cell(1, length(subject));
    % Go through all sessions of each subject
    for j = 1:length(subject)
        subjects{1, i}{1, j} = (subject{j}.signal)';
        subjects{1, i}{2, j} = subject{j}.label;
    end
end

% Save subjects in a mat file
dataname = '..\bin\subjects_exp';
save(strcat(dataname, num2str(n_experiment)), 'subjects', '-v7.3');



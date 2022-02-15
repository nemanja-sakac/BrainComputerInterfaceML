function save_feat_matrix(subjects, en_type, harmonics, dir_name)
% SAVE_FEAT_MATRIX Extracts trials from all subjects into a single matrix 
% along with their labels and subject IDs and saves it into a table.

% Vectorize subject IDs and the total number of trials
[subj_id, n_trials] = vectorize_subj_id(subjects);
% Place all features into a single matrix
[feat_matrix, trial_class] = get_feat_matrix(subjects, n_trials);

%%
% Plot frequency histogram
% histogram(trial_class, 100);

%%
% Mapping frequencies into classes
for i = 1:length(trial_class)
    % 6.67 Hz = Class 1
    if (trial_class(i) < 7)
        trial_class(i) = 1;
	% 7.50 Hz = Class 2
    elseif (trial_class(i) >= 7 && trial_class(i) < 8)
        trial_class(i) = 2;
	% 8.50 Hz = Class 3
    elseif (trial_class(i) >= 8 && trial_class(i) < 9)
        trial_class(i) = 3;
    % 10.00 Hz = Class 4
    elseif (trial_class(i) >= 9 && trial_class(i) < 10)
        trial_class(i) = 4;
    % 12.00 Hz = Class 5
    elseif (trial_class(i) >= 10)
        trial_class(i) = 5;
    end
end

%%
% Save features, labels and subject IDs
final_matrix = [feat_matrix, trial_class, subj_id];
if strcmp(en_type, 'rel')
    if strcmp(harmonics, 'no_harmonics')...
            || strcmp(harmonics, 'harmonics')
        feat_table = array2table(final_matrix,...
            'VariableNames',...
                {'mean_667',...
                'mean_750',...
                'mean_850',...
                'mean_1000',...
                'mean_1200',...
                'var_667',...
                'var_750',...
                'var_850',...
                'var_1000',...
                'var_1200',...
                'entropy',...
                'class',...
                'id_subject'});
    elseif strcmp(harmonics, 'harmonics_sep')
        feat_table = array2table(final_matrix,...
            'VariableNames',...
                {'mean_667',...
                'mean_750',...
                'mean_850',...
                'mean_1000',...
                'mean_1200',...
                'mean_harm2_667',...
                'mean_harm2_750',...
                'mean_harm2_850',...
                'mean_harm2_1000',...
                'mean_harm2_1200',...
                'mean_harm3_667',...
                'mean_harm3_750',...
                'mean_harm3_850',...
                'mean_harm3_1000',...
                'mean_harm3_1200',...
                'mean_harm4_667',...
                'mean_harm4_750',...
                'mean_harm4_850',...
                'mean_harm4_1000',...
                'mean_harm4_1200',...
                'var_667',...
                'var_750',...
                'var_850',...
                'var_1000',...
                'var_1200',...
                'var_harm2_667',...
                'var_harm2_750',...
                'var_harm2_850',...
                'var_harm2_1000',...
                'var_harm2_1200',...
                'var_harm3_667',...
                'var_harm3_750',...
                'var_harm3_850',...
                'var_harm3_1000',...
                'var_harm3_1200',...
                'var_harm4_667',...
                'var_harm4_750',...
                'var_harm4_850',...
                'var_harm4_1000',...
                'var_harm4_1200',...
                'entropy',...
                'class',...
                'id_subject'});
    end
elseif strcmp(en_type, 'snr')
    % Form tables with regards to fundamental frequencies(667, 750...) and 
    % the number of electrodes (1, 2, 3)
    feat_table = array2table(final_matrix,...
        'VariableNames',...
            {'snr_667_1',...
            'snr_750_1',...
            'snr_850_1',...
            'snr_1000_1',...
            'snr_1200_1',...
            'snr_667_2',...
            'snr_750_2',...
            'snr_850_2',...
            'snr_1000_2',...
            'snr_1200_2',...
            'snr_667_3',...
            'snr_750_3',...
            'snr_850_3',...
            'snr_1000_3',...
            'snr_1200_3',...
            'class',...
            'id_subject'});
end
        
% Save tables into a directory specified by 'dir_name'
writetable(feat_table, dir_name)




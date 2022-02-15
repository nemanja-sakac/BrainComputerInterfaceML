function v_car = car(input_signal)
% CAR(INPUT_SIGNAL) Removes artefacts from an INPUT_SIGNAL in accordance 
% with the Common Average Reference (CAR) method. The method removes 
% artefacts common to electrodes sharing the same reference electrode. 
%
% Input parameters:
%   INPUT_SIGNAL - Recorded signal. Rows represent samples in time and
%       columns the electrode channels
% Output parameters:
%   V_CAR - Signal cleared of common artefacts.

v_car = zeros(size(input_signal, 1), size(input_signal, 2));
for i = 1:size(v_car, 2)
    v_car(:, i) = input_signal(:, i) - mean(input_signal, 2);
end
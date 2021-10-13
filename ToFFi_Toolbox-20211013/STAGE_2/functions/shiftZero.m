function outputSourcesPower = shiftZero(sourcesPower)
%%
% Makes changes of power relative to the mean power spectrum more apparent.
% Values that were normalized before attain value 1 if the power is equal to the
% mean power. After using this shift function positive values means 'greater
% than mean power', negative values means 'smaller than mean power' and 0 if
% the power is equal to the mean power (power spectrum that all spectra was
% normalized by).
%% Inputs
% *sourcesPower* - double; 3D-array that contains normalized values of power
%                  spectrum for each time segment (trial) and frequency.
%                  Size: trials x frequencies.
%% Outputs
% *out1* - what it represents?; type; size; is it an output of other fun?;
%%
outputSourcesPower  = sourcesPower - 1;

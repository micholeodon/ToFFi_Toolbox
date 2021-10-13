function checkTrials_Warn_NaN_or_Infinities(cfg, trialDataInCells)
%%
% Check if data stored in the input cell contains NaNs or Infs.
%% Inputs
% *trialDataInCells* - cell containing 2D-arrays (sensors x time frames)
%                      signal values for single epochs of the multichannel
%                      signal (time segments).
%
% *cfg* - char; can equal [] or contain an arbitrary and possibly informative
%         name of the input structure *trialDataInCells*.
%%

if(~iscell(trialDataInCells)) error('input argument is not a cell !'); end

for iCell = 1:length(trialDataInCells)
    if(ischar(trialDataInCells{iCell})) error('input argument cannot contain chars or strings !'); end
end

concatenated    = [trialDataInCells{:}];
reshaped        = reshape(concatenated, 1, []);

if(any(isnan(reshaped)))
    warning([cfg.name, ': contains NaNs !']);
end

if(any(isinf(reshaped)))
    warning([cfg.name, ': contains Infinities (Inf) !']);
end

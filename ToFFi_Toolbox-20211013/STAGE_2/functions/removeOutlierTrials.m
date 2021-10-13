function [dataCleaned, rejectInfo] = removeOutlierTrials(cfg, dataTrialed)
%%
% Removes trials whose power level (mean power across frequencies) is
% extreme, i.e. trials in which absolute value of z-score exceeds cfg.zThreshold.
%% Inputs
% *cfg* - struct; configuration with fields:
%
% _zThreshold_ - double; positive real number. If z-score (along columns of
%                *dataTrialed* matrix) for given row of the *dataTrialed*
%                matrix if more than this number that trial will be rejected.
%
% _dimord_ - char; describes the order of dimensions in *dataTrialed*
%            matrix. Should equal 'rpt_src_freq' or 'rpt_chan_freq'
% (More about: https://www.fieldtriptoolbox.org/development/datastructure/)
%
% *dataTrialed* - double; 2D-array that contains values of power spectrum for
%                 each time segment and frequency.
%                 Size: trials x frequencies.
%% Outputs
% *dataCleaned* - double; 2D-array that contains values of power spectrum for
%                 each time segment and frequency.
%                 Size: trials x frequencies.
%
% *rejectInfo* - struct with fields:
%
% _rejectedTrialsIndices_ - double; 1D-array containing row indices that were
%                           removed from *dataTrialed* matrix
%
% _nTrialsBeforeRejection_ - double; integer that counts how many trials
%                            exceeded cfg.zThreshold and were thus rejected.
%%
disp('Removing trials with extreme power level ...');

%
if(~isfield(cfg, 'zThreshold')) error('No zThreshold field in cfg !'); end
if(~isnumeric(cfg.zThreshold)) error('cfg.zThreshold should be numeric !'); end
if(~isfield(cfg, 'dimord')) error('No dimord field in cfg !'); end
isWrongFirstDimension   = ~strcmp('rpt' , cfg.dimord(1:3));
isWrongLastDimension    = ~strcmp('freq', cfg.dimord(end-3 : end));

if(any([isWrongFirstDimension, isWrongLastDimension]) )
    error('Data dimensions are in wrong order ! Should be: trial (rpt) x source / channel (src/chan) x frequency (freq)')
end

%
nTrials        = size(dataTrialed, 1);
nFrequencies   = size(dataTrialed, 2);

meanPowerLevel_Trials   = mean(dataTrialed, 2);
meanPowerLevel_Trials   = squeeze(meanPowerLevel_Trials);
assert(isequal(size(meanPowerLevel_Trials), [nTrials, 1]))

zMeanPowerLevel_Trials  = zscore(meanPowerLevel_Trials);
outlierTrialsIndices    = find(abs(zMeanPowerLevel_Trials) > cfg.zThreshold);

dataCleaned                             = dataTrialed;
dataCleaned(outlierTrialsIndices, :, :) = [];
rejectInfo.rejectedTrialsIndices       = outlierTrialsIndices;
rejectInfo.nTrialsBeforeRejection      = nTrials;

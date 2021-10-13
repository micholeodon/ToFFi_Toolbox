function sourcesNormalizedActivity = normalizeActivityROIwise(cfg, sourcesPower)
%%
% Normalizes power spectrum values inside sourcesPower matrix so each becomes
% a ratio of the average power spectrum of brain region given source belongs
% to and all time segments.
% This normalisation results in values above/below one. Size of the input
% structure is left intact.
%
% Relies on normalizeSpectraInSelectedVoxels.m routine.
%% Inputs
% *cfg* - struct containing field:
%
% _sourceModel_ - struct; output of prepareSourceModel.m routine
%
% _sourceAtlasSingle_ - struct; single structure from sourceAtlas output of
%                       prepareAtlas.m routine 
%
% *sourcesPower* - double; 3D-array that contains values of power spectrum for
%                  each time segment (trial), source and frequency.
%                  Size: trials x sources x frequencies.
%% Outputs
% *sourcesNormalizedActivity* - double; 3D-array that contains values of
%                               normalized power spectrum for each time
%                               segment (trial), source/sensor and frequency.
%                               Size: trials x sources x frequencies.
%%

if(~isfield(cfg, 'sourceModel')) error('no sourceModel field in cfg argument'); ...
end
if(~isfield(cfg, 'sourceAtlasSingle')) error(['no sourceAtlasSingle field in ' ...
                        'cfg argument']); end

disp('Normalize activity (ROI-wise normalization + non-ROI voxels normalized by mean of their value) ...')

sourceAtlasSingle = cfg.sourceAtlasSingle;
sourceModel = cfg.sourceModel;

nFrequencies    = size(sourcesPower,3);
nSources        = size(sourcesPower,2);
nTrials         = size(sourcesPower,1);
nROI            = length(sourceAtlasSingle.tissuelabel);

sourcesNormalizedActivity = sourcesPower;

% ROI voxels
for iROI = 1:nROI
    cfg.selectedVoxels  = getRoiInsideIndices(iROI, sourceAtlasSingle, sourceModel);
    [sourcesPowerWithSomeVoxelsNormalized, isEmptySelection] = normalizeSpectraInSelectedVoxels(cfg, sourcesPower);

    if(isEmptySelection)
        continue; % skip ROI
    end

    sourcesNormalizedActivity(:,cfg.selectedVoxels,:) = sourcesPowerWithSomeVoxelsNormalized(:,cfg.selectedVoxels,:);

    clear sourcesPowerWithSomeVoxelsNormalized
end

% non-ROI voxels
cfg.selectedVoxels  = getRoiInsideIndices('nonroi', sourceAtlasSingle, sourceModel);
if(length(cfg.selectedVoxels > 0))
    sourcesPowerWithSomeVoxelsNormalized = normalizeSpectraInSelectedVoxels(cfg, sourcesPower);

    sourcesNormalizedActivity(:,cfg.selectedVoxels,:) = sourcesPowerWithSomeVoxelsNormalized(:,cfg.selectedVoxels,:);

    clear sourcesPowerWithSomeVoxelsNormalized
end

% check size of the output variable
if(~isequal(size(sourcesNormalizedActivity), size(sourcesPower)))
    error('Size of sourcePower and output structure differs. Something wrong with indices in code.');
end

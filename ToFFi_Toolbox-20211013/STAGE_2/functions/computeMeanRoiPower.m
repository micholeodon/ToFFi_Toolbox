function roiPower = computeMeanRoiPower(cfg, iSub, iROI, sourcesPower)
%%
% Computes average power spectrum across all voxels of the selected ROI.
%% Inputs
% *cfg* - struct containing field:
%
% _sourceAtlasAndSourceModel_ - struct with fields:
%
%     _sourceModel_ - struct; output of prepareSourceModel.m routine
%
%     _sourceAtlas_ - struct; output of prepareAtlas.m routine
%
%     _areNonRoiVoxelPresent_ - double; 0 (all voxels from atlas has assigned
%                               ROI) or 1 (there are voxels that have no
%                               assigned ROI).
%
% _mode_ - (optional) char; when eqals 'rand' cfg.numRandVox number of voxels
%          (instead of all the ROI voxels) is randomly chosen from selected
%          ROI and average of their activity serves as ROI power.
%
% _numRandVox_ - (optional) double; integer number of voxels to be randomly
%                chosen from selected ROI.
%
% _iGoodSub_ - double positive integer; position of the *iSub* in the
%              CFG.Global.goodSubjects list
%
% *iSub* - double; integer index of subject for whom power will be computed
%
% *iROI* - double; integer index of ROI to be selected. Average power across
%          its voxels will be computed.
%
% *sourcesPower* - struct with field:
%
% _powerSpectrum_ - double; 3D-array that contains values of power spectrum for
%                   each time segment (trial), voxel and frequency.
%                   Size: trials x voxels x frequencies.
%% Outputs
% *roiPower* - double; 2D-array that contains values of power spectrum for
%              each time segment (trial) and frequency.
%              Size: trials x frequencies.
%%
iGoodSub = cfg.iGoodSub;

disp('Computing mean ROI power ...')

if(~isfield(cfg, 'sourceAtlasAndSourceModel')) error('No sourceAtlasAndSourceModel field in cfg !'); end

sourceAtlas = cfg.sourceAtlasAndSourceModel.sourceAtlas;
nAtlas = numel(sourceAtlas);
if(nAtlas>1)
    sourceAtlasSingle = sourceAtlas(iGoodSub)
else
    sourceAtlasSingle = sourceAtlas(1);
end
sourceModel = cfg.sourceAtlasAndSourceModel.sourceModel;

nTrials = size(sourcesPower.powerSpectrum, 1);
nFrequencies = size(sourcesPower.powerSpectrum, 3);

roiIndices          = getRoiInsideIndices(iROI, sourceAtlasSingle, sourceModel);
if(isempty(roiIndices))
    error(['computeMeanRoiPower: ROI', num2str(iROI), ' has empty list of voxels indices !'])
end


if(isfield(cfg, 'mode'))
    switch cfg.mode
      case 'rand' % select few voxels (no repeats) and compute mean
	nVox = cfg.numRandVox;
	idx = randperm(numel(roiIndices), nVox);
	roiIndicesSelected = roiIndices(idx);
	roiPower  = reshape(mean(sourcesPower.powerSpectrum(:,roiIndicesSelected,:), 2), nTrials, nFrequencies);
      otherwise
	% pretend there is no cfg.mode field
	roiPower  = reshape(mean(sourcesPower.powerSpectrum(:,roiIndices,:), 2), nTrials, nFrequencies);
    end
else
    roiPower  = reshape(mean(sourcesPower.powerSpectrum(:,roiIndices,:), 2), nTrials, nFrequencies);
end

function [pooledClusters, nClustersPerRoi] = prepareData_Stage6(CFG)
%%
% Prepare data for this stage considering stage configuration stored in *CFG*
% input variable.
%%

STAGE_NAME = 'STAGE_6';

disp('Loading and preparing data (clusters pooled from all subjects) ...')
% check pooled clusters presence
[list_data, isMissingData] = checkStageDataPresence(CFG.(STAGE_NAME))

% load pooled clusters set
loadData
pooledClusters

% check clustering evaluation datafile presence (if needed)
nClustersPerRoi             = set_nClustersPerRoiForTraining(CFG, STAGE_NAME);

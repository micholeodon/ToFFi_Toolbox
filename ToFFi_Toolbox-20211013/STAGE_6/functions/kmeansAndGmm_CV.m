function roiModel = kmeansAndGmm_CV(CFG, k, roiModel, aux)
%%
% Preforms k-means and gaussian mixture modelling for single ROI on data
% collected from training subjects. It should be used for cross-validation.
%% Inputs
% *CFG* - struct with obligatory fields:
%
% _STAGE_6_ - structure containing configuration for STAGE_6.
%
% *k* - double; positive integer >2; number of clusters to be discovered in data.
%
% *roiModel* - struct with fields:
%
% _iROI_ - double; integer; ROI index
%
% _nRoiAtlas_ - double; integer positive number of ROI defined in used brain
%               atlas.
%
% _goodROI_ - double; 1D-array with ROI indices used in the analysis
%
% _centroidsFromTrSub_ - double; 2D-array where each row represents single
%                        point in multidimensional frequency space. Each
%                        point has its "owner" i.e. subject who it belongs
%                        to. Number of columns is equal to the dimensionality
%                        of the frequency space.
%
% _centroidsTrSubIndices_ - double; 1D-aray of same number of entries as the
%                           number of rows in the
%                           _centroidsFromTrSub_. Possible values are subject
%                           indices that fell into training folds.
%
% *aux* - struct with additional data with fields:
%
% _STAGE_NAME_ - char; name of the stage used in *CFG* variable to access
%                configuration related to this stage.
%
% _iRep_ - double; integer; current CV repetition number
%
% _iFold_ - double; integer; current validation fold in
%           current CV repetition;
%
% _iROI_ - double; integer; ROI index;
%
% _trSub_ - double; list of subject indices that fell into training folds;
%
% _pooledClusters_ - array of structs (size 1 x _nRoiAtlas_) with fields:
%
%       numCentroidsPerSubject - double; 1D-array with numbers that mean how
%                                many spectral modes (aka centroids) was
%                                computed in STAGE_2 for particular subject
%                                (one number relates to one subject).
%
%       centroidsAllSubjects - double; 2D-array where each row represents single
%                              point in multidimensional frequency space (this
%                              point is called spectral mode). Each point has
%                              its "owner" i.e. subject who it belongs
%                              to. Points were appended row-by-row, first all
%                              points from first subjects, then all points
%                              from second subject and so on. Total number of
%                              rows equal sum of the numbers in
%                              _numCentroidsPerSubject_ field. Number of
%                              columns is equal to the dimensionality of the
%                              frequency space.
%
%       centroidsSubjectIndices - double; 1D-array that has as many rows as
%                                 _centroidsAllSubjects_ field. Contains indices
%                                of subject that "owns" particular point (row in
%                                _centroidsAllSubjects_ field)
%
%       centroidsDuration - cell of 1D-arrays storing time duration of each
%                           spectral mode expressed in percent. Each array
%                           contains data for single subject.
%
%       iROI - double; integer; ROI index;
%
%       nRoiAtlas - double; integer positive number of ROI defined in used
%                   brain atlas.
%
%       goodROI - double; 1D-array with ROI indices used in the analysis
%
%       freqAxis - double; 1D-array of frequencies in Hz.
%
% _nClustersPerRoi_ - array of cells (size 1 x _nRoiAtlas_). Each cell
%                     contains number of clusters for each ROI.
%% Outputs
% *roiModel* - same as in input but with appended data from current call of
%              the function.
%%

STAGE_NAME = aux.STAGE_NAME;
iRep = aux.iRep;
iFold = aux.iFold;
iROI = aux.iROI;

cfg = [];
cfg.distanceMetric  = CFG.(STAGE_NAME).clustering.(CFG.STAGE_6.clusteringMethod).distanceMetric;
cfg.nReplicates     = CFG.(STAGE_NAME).clustering.(CFG.STAGE_6.clusteringMethod).nReplicates;
cfg.nClusters       = k;
cfg.dataFieldName   = 'centroidsFromTrSub';
cfg.prefixToFields  = '';
evalc('roiModel = cluster_Kmeans(cfg, roiModel)');

% gaussian mixture modelling
cfg = [];
cfg.regularization          = CFG.(STAGE_NAME).gaussianMixtureRegularization;
cfg.nClusters               = k;
cfg.dataFieldName           = 'centroidsFromTrSub';
cfg.startClustersFieldName  = 'kMeans_pointsClusterIndices';
cfg.prefixToFields          = '';
cfg.logPath                 = '../output/';
cfg.logColNames             = {'iRep', 'iFold', 'iROI'};
cfg.logColValues            = [iRep, iFold, iROI];
nPoints                     = size(roiModel.centroidsFromTrSub,1);
nDim                        = size(roiModel.centroidsFromTrSub,2);
if(nPoints <= nDim)
    cfg.initialModel.mu = roiModel.kMeans_centroids;
    cfg.initialModel.Sigma = [];
    cfg.initialModel.PComponents = [];
end
evalc('roiModel = gaussianMixtureModelling(cfg, roiModel)');

function singleRoiPooledClustersData = appendSubjectDependentData(cfg, singleRoiPooledClustersData, singleSubjectClustersData)
%%
% Appends data related to computed Individual Fingerprints (related to single
% subject and single ROI) into single structure that store data separately
% for each ROI.
%% Inputs
% *cfg* - struct; with fields:
%
% _iROI_ - double; integer index of current ROI being appended data to
%
% _goodROI_ - double; 1D-array with ROI indices used in the analysis
%
% *singleRoiPooledClustersData* - struct; Used fields:
%
% _numCentroidsPerSubject_ - double; 1D-array with numbers that mean how many
%                            spectral modes (aka centroids) was computed for
%                            particular subject (one number relates to one
%                            subject)
%
% _centroidsAllSubjects_ - double; 2D-array where each row represents single
%                          point in multidimensional frequency space (this
%                          point is called spectral mode). Each point has its
%                          "owner" i.e. subject who it belongs to. Points are
%                          appended row-by-row, first all points from first
%                          subjects, then all points from second subject and
%                          so on. Total number of rows equal sum of the
%                          numbers in _numCentroidsPerSubject_ field. Number
%                          of columns is equal to the dimensionality of the
%                          frequency space.
%
% _centroidsSubjectIndices_ - double; 1D-array that has as many rows as
%                             _centroidsAllSubjects_ field. Contains indices
%                             of subject that "owns" particular point (row in
%                             _centroidsAllSubjects_ field)
%
% _centroidsDuration_ - cell of 1D-arrays storing time duration of each
%                       spectral mode expressed in percent. Each array
%                       contains data for single subject.
%
% *singleSubjectClustersData* - struct with data related to Individual
%                               Fingerprint for subject _iSub_; Used fields:
%
% _spectralModes_ - cell containing 2D-array of doubles where each row
%                   represents single point in multidimensional frequency
%                   space (this point is called spectral mode). Each cell
%                   element is related to one ROI.
%
% _iSub_ - double; integer index of the subject data in the
%          structure belongs to
%
% _clusterDuration_ - cell of 1D-arrays storing time duration of each
%                     spectral mode expressed in percent. Each array
%                     contains data for one ROI of subject _iSub_.
%% Outputs
% *singleRoiPooledClustersData* - same as in input but with appended new data.
%%

if(~isfield(cfg, 'iROI')) error('Missing field in cfg argument !'); end
if(~isfield(cfg, 'goodROI')) error('Missing field goodROI in cfg argument !'); end
if(~ismember(cfg.iROI, cfg.goodROI)) error('Selected ROI is not in goodROI list'); end

iROI = cfg.iROI;

nAppendedCentroids = size(singleSubjectClustersData.spectralModes{iROI},1);

singleRoiPooledClustersData.numCentroidsPerSubject = ...
    [ singleRoiPooledClustersData.numCentroidsPerSubject , nAppendedCentroids];

singleRoiPooledClustersData.centroidsAllSubjects = ...
    [ singleRoiPooledClustersData.centroidsAllSubjects ; singleSubjectClustersData.spectralModes{iROI}];

singleRoiPooledClustersData.centroidsSubjectIndices = ...
    [ singleRoiPooledClustersData.centroidsSubjectIndices ; repmat(singleSubjectClustersData.iSub, nAppendedCentroids, 1) ];

singleRoiPooledClustersData.centroidsDuration{end+1} = singleSubjectClustersData.clusterDuration{iROI};

function [centroidsFromSelectedSubjects, centroidsIDs, centroidsSubjectLabels] = get_selectedSubjectsCentroids(cfg, pooledClustersInSingleROI)
%%
% Selects a subset of centroids that match list of subjects to be selected.
%% Inputs
% *cfg* - struct with field:
%
% _selectedSubjectIndices_ - double; 1D array with integer indices of
%                            selected subjects
%
% *pooledClustersInSingleROI* - struct with fields:
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
% _iROI_ - double; integer; ROI index
%
% _nRoiAtlas_ - double; integer positive number of ROI defined in used brain
%               atlas.
%
% _goodROI_ - double; 1D-array with ROI indices used in the analysis
%
% _freqAxis_ - double; 1D-array of frequencies in Hz
%% Outputs
% *centroidsFromSelectedSubjects* - same as
% *pooledClustersInSingleROI.centroidsAllSubjects* but contains only
% centroids related to selected subjects.
%
% *centroidsIDs* - double; 1D-array of numbers of
% *pooledClustersInSingleROI.centroidsAllSubjects* that was selected.
%
% *centroidsSubjectLabels - double; 1D-array of same number of elemets as
% number of rows in *centroidsFromSelectedSubjects* output. Contains subject
% indices related to those centroids.
%%

disp('Selecting centroids from subjects: ')

if(~isfield(cfg, 'selectedSubjectIndices')) error('Missing field selectedSubjectIndices in cfg argument !'); end

disp(num2str(cfg.selectedSubjectIndices));

idx = cell(1, numel(cfg.selectedSubjectIndices));

% I allow to repeat points (because subject also repeat) and thus not allow
% for errors like 'too few points to cluster'.
centroidsSubjectLabels = [];
for ii = 1:length(cfg.selectedSubjectIndices)
    iSub = cfg.selectedSubjectIndices(ii);
    idx{ii} = find(pooledClustersInSingleROI.centroidsSubjectIndices == iSub);
    centroidsSubjectLabels = [centroidsSubjectLabels, repmat(iSub, 1, numel(idx{ii}))];
end


idx = cellfun(@transpose,idx,'UniformOutput',false);
IDX = [idx{:}];
centroidsFromSelectedSubjects   = pooledClustersInSingleROI.centroidsAllSubjects(IDX, :);
centroidsIDs         = IDX';

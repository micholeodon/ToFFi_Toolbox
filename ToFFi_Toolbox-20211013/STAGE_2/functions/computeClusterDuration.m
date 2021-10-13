function  individualFingerprint = computeClusterDuration(cfg, individualFingerprint)
%%
% Calculates percentages of points belonging to each cluster.
%% Inputs
% *cfg* - struct; configuration with fields:
%
% _nSpectralModesPerROI_ - double; integer number of clusters.
%
% *individualFingerprint* - struct with obligatory field:
%
% _trialsSpectralModeMembership_ - double; 1D array containing cluster index
%                                  for each of the clustered points.
%% Outputs
% *individualFingerprint* - struct; Same as in input but extended with new field:
%
% _clusterDuration_ - double; 1D-array containing percentages of points
%                     belonging to each cluster.
%%

disp('Computing trial duration ...')

if(~isfield(cfg, 'nSpectralModesPerROI')) error('Missing field nSpectralModesPerROI in cfg input argument !'); end
if(~isfield(individualFingerprint, 'trialsSpectralModeMembership')) error('Missing field trialsSpectralModeMembership in individualFingerprint input argument !'); end
if(~isstruct(individualFingerprint)) error('individualFingerprint argument is not a struct !'); end


clusterDuration             = zeros(1, cfg.nSpectralModesPerROI);
trialsClustersMembership    = individualFingerprint.trialsSpectralModeMembership;

if(numel(trialsClustersMembership) == 0)
    error('trialsClustersMembership is empty !');
end

for iCluster = 1:cfg.nSpectralModesPerROI
    clusterTrialsIndices        = find(trialsClustersMembership==iCluster);
    clusterDuration(iCluster)   = length(clusterTrialsIndices);
    clusterDuration(iCluster)   = clusterDuration(iCluster)/length(trialsClustersMembership)*100;
end

individualFingerprint.clusterDuration = clusterDuration;

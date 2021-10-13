function individualFingerprint = gaussianMixtureModelling_IF(cfg, singleSubjectSingleRoiData)
%%
% Performs soft-clustering using EM algorithm and next hard clustering on the
% result. Uses standard MATLAB fitgmdist and cluster routines with additional
% initial sorting (result is invariant to the order of rows of the data
% matrix). Estimates input data distribution by the Gaussian Mixture Model.
%% Inputs
% *cfg* - struct; configuration with fields:
%
% _regularization_ - double; real number λ between 0 and 1. Represents amount
%                    of regularization to be applied to covariance
%                    matrices. At the end of each iteration of the EM
%                    algorithm, λ is added to every diagonal element of the
%                    covariance matrix (track _regVal_ variable inside
%                    gmcluster_learn function inside gmcluster routine called
%                    by gmdistribution.fit inside fitgmdist.m MATLAB function).
%
% _nClusters_ - double; integer number of clusters to be found in the data.
%
% _logPath_ - (optional) path to the log file to be created that store
%             information about subjects and ROI for which EM algoritm not
%             converged. See globalFunctionsScripts/logNotConverged.m for
%             details.
%
% *singleSubjectSingleRoiData* - struct; Contains data to be clustered for
%                                the single subject. Obligatory fields:
%
% _normalizedPowerSpectrum_Trials_ - double; 2D-array that contains values of
%                                    normalized power spectrum for each time
%                                    segment and frequency. Each row
%                                    represents single point.
%                                    Size: trials x frequencies.
%
% _trialsClusterIndices_ - double; 1D array containing cluster index for each
%                          of the clustered points in the input data matrix.
%                          Contain values from 1 to cfg.nClusters.
%
% _iROI_ - double; integer index of the ROI that *singleSubjectSingleRoiData*
%          structure represents
%
% _iSub_ - double; integer index of the subject that *singleSubjectSingleRoiData*
%          structure represents
%% Outputs
% *individualFingerprint* - *singleSubjectSingleRoiData* extended with new
%                           fields:
%
% _gmClassInstance_ - object that stores a Gaussian mixture model (GMM), which is
%                     a multivariate distribution that consists of
%                     multivariate Gaussian distribution components.
%                     Further details:
% (https://www.mathworks.com/help/stats/gmdistribution.html)
%
% _didGmmConverge_ - double; 0 (EM algorithm did not converge) or 1 (EM
%                    algorithm has converged)
%
% _spectralModes_ - double; 2D-array of size cfg.nClusters x frequencies. Each
%                  row contain single gaussian component center. Equals to
%                  _gmClassInstance.mu_. In Spectral Fingerprinting jargon
%                  each component is called spectral mode.
%
% _trialsSpectralModeMembership_ - double; 1D-array containing cluster index
%                                  for each of the clustered points in the
%                                  input data matrix. Contains values from 1
%                                  to cfg.nClusters.
%
% _emptyClusters_ - double; 1D-array containing cluster indices that has zero
%                   points assigned to it. Such situation can happen if the
%                   input data are degenerated or parameters force that some
%                   of the resulting spectral modes are identical. In that
%                   situation one of the "twins" have no points assigned to
%                   it, because they were "stolen" by its "sibling".
%
% Following fields are removed: 'roiWithinClusterDistance', 'roiCentroids',
% 'trialsClusterIndices', 'nTrialsBeforeRejection', 'rejectedTrialsIndices',
% 'normalizedPowerSpectrum_Trials'.
%
%%

disp('Gaussian Mixture modelling ...')

if(~isfield(cfg, 'regularization')) error('Missing field regularization in cfg input argument !'); end
if(~isfield(cfg, 'nClusters'))    error('Missing field nClusters in cfg input argument !');  end

% Gaussian Mixture clustering; uses k-means cluster as starting point

roiPowerSpectrum_Trials = singleSubjectSingleRoiData.normalizedPowerSpectrum_Trials;
roiTrialsClusterIndices = singleSubjectSingleRoiData.trialsClusterIndices;

options   = statset('Display','final','MaxIter',1000);

gmClassInstance = fitgmdist(roiPowerSpectrum_Trials, cfg.nClusters,  ...
    'Start', roiTrialsClusterIndices, ...
    'Options', options, ...
    'Regularize', cfg.regularization );
% NOTE: INITIAL VALUES of MU, SIGMA and PComponents before fitting
% (see lines 536-544 in MATLAB/toolbox/stats/stats/@gmdistribution/private/gmcluster.m)
%
% Cluster indices are from k=1:K
% For each k:
% 1. X0 matrix of all points with label == k (each row is single point)
% 2. Compute mean across rows to get mu_k
% 3. X0 = X0 - mu_k  (center the matrix)
% 4. Compute non-regularized covariance matrix Sigma = X0' * X0
% 5. Divide by total number of points and add regularization by \lambda * identity matrix:
%       Sigma = Sigma/n +  lambda * I;
% 6. Proporion PComponents is given by the ratio:
%       p_k = (number of points with label k) / n

didConverge = gmClassInstance.Converged;

if(isfield(cfg, 'logPath'))
    if(didConverge == 0)
	cfgLog = [];
	cfgLog.colValues = [singleSubjectSingleRoiData.iSub, ...
	    singleSubjectSingleRoiData.iROI ];
	cfgLog.colNames = {'iSub', 'iROI'};
	cfgLog.logPath  = cfg.logPath;
	logNotConverged(cfgLog)
    end
end

% sort components (helps averaging and reproducibility)
[sorted_mu, idx]    = sortrows(gmClassInstance.mu);
sorted_Sigma        = gmClassInstance.Sigma(:,:, idx);
sorted_PComponents  = gmClassInstance.PComponents(idx);
gmClassInstance     = gmdistribution(sorted_mu, sorted_Sigma, sorted_PComponents);

individualFingerprint = singleSubjectSingleRoiData;
individualFingerprint = rmfield(individualFingerprint, ...
    {'roiWithinClusterDistance', 'roiCentroids', ...
    'trialsClusterIndices', 'nTrialsBeforeRejection', ...
    'rejectedTrialsIndices', 'normalizedPowerSpectrum_Trials'});
individualFingerprint.didGmmConverge = -1; % initially assuming that not converged
individualFingerprint.gmClassInstance               = gmClassInstance;
individualFingerprint.didGmmConverge               = didConverge;
individualFingerprint.spectralModes                 = gmClassInstance.mu; % 1-st level clusters
individualFingerprint.trialsSpectralModeMembership  = cluster(gmClassInstance, roiPowerSpectrum_Trials);
clear singleSubjectSingleRoiData

% Noting down empty clusters.
% After using cluster function trials will be assigned to subset of
% spectralModes because some of the modes are identical. Some modes
% (clusters) will be empty and also have zero time duration
% (calculated in other function).
individualFingerprint.emptyClusters = setdiff(...
    1:cfg.nClusters, ...
    unique(individualFingerprint.trialsSpectralModeMembership)...
    )

function inputStructure = gaussianMixtureModelling(cfg, inputStructure)
%%
% Performs soft-clustering using EM algorithm and next hard clustering on the
% result. Uses standard MATLAB fitgmdist and cluster routines with additional
% initial sorting (result is invariant to the order of rows of the data
% matrix). Estimates input data distribution by the Gaussian Mixture Model.
%% Inputs
% *cfg* - struct with fields:
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
% _dataFieldName_ - char; name of the field in the *inputStructure*
%                   containing data matrix to be clustered
%
% _prefixToFields_ - (optional) char; prefix that will be added at the
%                    beginning of each new field created in the
%                    *inputStructure*, e.g. if _prefixToFields_ = 'lvl2_',
%                    following fields will be added to *inputStructure*:
%                    _lvl2_gmm_gmClassInstance_
%                    _lvl2_gmm_didGmmConverge_
%                    _lvl2_gmm_centroids_
%                    _lvl2_gmm_pointsMembership_
%
% _startClustersFieldName_ - double; 1D-array containing initial cluster index
%                            for each of the points to be clustered in the
%                            input data matrix. Should contain values from 1
%                            to cfg.nClusters.
%
% _initialModel_ - struct with initial gaussian mixture model. Should contain
%                  fields: _mu_, _Sigma_ and _PComponents_ (aka
%                  _ComponentProportion_). For details see "Distribution
%                  Parameters" section at:
%                  https://www.mathworks.com/help/stats/gmdistribution.html#d122e402597)
%
% _logPath_ - (optional) path to the log file to be created that store
%             information about subjects and ROI for which EM algoritm not
%             converged. If this field present, also additional cfg fields
%             becomes obligatory: logColValues (values to append for each
%             column), logColNames (cell array of columns names). See
%             globalFunctionsScripts/logNotConverged.m for details.
%
% *inputStructure* - struct with two obligatory fields:
%                    1) First containing data to be clustered. This data
%                    field should have same name as name stored in
%                    *cfg.dataFieldName*. Data should be a double 2D-array of
%                    size N x D, where N is the number of observations to be
%                    clustered and D is the number of dimensions /
%                    variables.
%                    2) Second containing initial clusters indices for each
%                    input point to be clustered. Should be double 1D-array
%                    with N values, where N is the number of observations to be
%                    clustered. This data field should have same name as name
%                    stored in *cfg.startClustersFieldName*.
%% Outputs
% *inputStructure* - same struct as in input but containing additional fields:
%
%     _gmm_gmClassInstance_ - object that stores a Gaussian mixture model
%                             (GMM), which is a multivariate distribution
%                             that consists of multivariate Gaussian
%                             distribution components. Further details:
% (https://www.mathworks.com/help/stats/gmdistribution.html)
%
%     _gmm_didGmmConverge_ - double; 0 (EM algorithm did not converge) or 1 (EM
%                            algorithm has converged)
%
%     _gmm_centroids_ - double; 2D-array of size cfg.nClusters x D, where D
%                       is the number of dimensions / variables. Each row
%                       contain single gaussian component center. Equals to
%                       _gmm_gmClassInstance.mu_.
%
%     _gmm_pointsMembership_ - double; 1D-array containing cluster index
%                              for each of the clustered points in the
%                              input data matrix. Contains values from 1
%                              to cfg.nClusters.
%%

disp('Gaussian Mixture modelling ...')

if(~isfield(cfg, 'regularization'))         error('Missing field regularization in cfg input argument !'); end
if(~isfield(cfg, 'nClusters'))              error('Missing field nClusters in cfg input argument !');  end
if(~isfield(cfg, 'dataFieldName'))          error('Missing field dataFieldName in cfg input argument !');  end
if(~isfield(cfg, 'startClustersFieldName')) error('Missing field startClustersFieldName in cfg input argument !');  end
if(~isfield(cfg, 'initialModel'))
    isInitModelProvided = 0;
else

    isInitModelProvided = 1;
    if(~isstruct(cfg.initialModel)) error('ERROR: cfg.initialModel should be a structure with fields mu, Sigma, PComponents !'); end
    if(~isfield(cfg.initialModel, 'mu')) error('ERROR: cfg.initialModel should be a structure with fields mu, Sigma, PComponents !'); end
    if(~isfield(cfg.initialModel, 'Sigma')) error('ERROR: cfg.initialModel should be a structure with fields mu, Sigma, PComponents !'); end
    if(~isfield(cfg.initialModel, 'PComponents')) error('ERROR: cfg.initialModel should be a structure with fields mu, Sigma, PComponents !'); end
end

if(~isfield(cfg, 'prefixToFields'))
    prefix = '';
elseif(isempty(cfg.prefixToFields))
    prefix = '';
else
    prefix = cfg.prefixToFields;
end

% Gaussian Mixture clustering; uses k-means cluster as starting point
inputStructure.([prefix, 'gmm_centroids'])          = []; % to be filled
inputStructure.([prefix, 'gmm_pointsMembership'])   = [];
inputStructure.([prefix, 'gmm_gmClassInstance'])    = [];
inputStructure.([prefix, 'gmm_didGmmConverge'])    = -1; % initially assuming that not valid

pointsToCluster         = inputStructure.(cfg.dataFieldName);
initialClustersIndices = inputStructure.(cfg.startClustersFieldName);

options   = statset('Display','final','MaxIter',1000);

nDim = size(pointsToCluster, 2);
N   = size(pointsToCluster, 1);

%% Check whether number of points is enough to start EM algorithm
% - if not then compute GM straight from the data in one step
if(N <= cfg.nClusters)
    error('Error: There should be more points to cluster than demanded number of clusters !');
else
    if N > nDim
	usingOneShotMethod = 0;
	disp('N > nDim  => using EM algorithm to fit GMM ...')

	if(isInitModelProvided)
	    gmClassInstance = fitgmdist(pointsToCluster, cfg.nClusters,  ...
		'Options',      options, ...
		'Regularize',   cfg.regularization, ...
		'Start',        cfg.initialModel);
	else
	    gmClassInstance = fitgmdist(pointsToCluster, cfg.nClusters,  ...
		'Start',        initialClustersIndices, ...
		'Options',      options, ...
		'Regularize',   cfg.regularization );
	    % INITIAL VALUES of MU, SIGMA and PComponents (see lines 536-544 in
	    % MATLAB/toolbox/stats/stats/@gmdistribution/private/gmcluster.m)
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

	end % if(isInitModelProvided)

    else
	usingOneShotMethod = 1;
	warning('N <= nDim  => using initial clustering to estimate GMM in one step ...')
	if(~isInitModelProvided)
	    error('ERROR! Provide structure cfg.initialModel with fields: mu with initial centroids (e.g. from k-means), Sigma empty, PComponents empty !')
	end

	mu  = zeros(cfg.nClusters, nDim);
	S   = zeros(nDim, nDim, cfg.nClusters);
	A   = zeros(1,cfg.nClusters);
	for iClust = 1:cfg.nClusters
	    idx = find(initialClustersIndices == iClust)';
	    Xcl = pointsToCluster(idx,:);
	    Ncl = size(Xcl,1);

	    % mu
	    mu(iClust,:) = cfg.initialModel.mu(iClust,:);
	    % proportion (not need to be in cfg.initialModel so model from kmeans will suffice)
	    A(iClust) = Ncl/N;
	    % covMatrix (not need to be in cfg.initialModel so model from kmeans will suffice)
	    S(:,:,iClust) = cov(Xcl) + cfg.regularization*eye(nDim);

	end % iClust

	gmClassInstance = gmdistribution(mu, S, A)
    end % if N > nDim

end % if N <= cfg.nClusters
%%

% sort components (helps averaging and reproducibility)
[sorted_mu, idx]    = sortrows(gmClassInstance.mu);
sorted_Sigma        = gmClassInstance.Sigma(:,:, idx);
sorted_PComponents  = gmClassInstance.PComponents(idx);
if usingOneShotMethod
    didConverge    = 1;
else
    didConverge    = gmClassInstance.Converged;
end
gmClassInstance = gmdistribution(sorted_mu, sorted_Sigma, sorted_PComponents);

if(isfield(cfg, 'logPath'))
    if(didConverge == 0)
	cfgLog = [];
	cfgLog.colValues = cfg.logColValues;
	cfgLog.colNames = cfg.logColNames;
	cfgLog.logPath  = cfg.logPath;
	logNotConverged(cfgLog)
    end
end

inputStructure.([prefix, 'gmm_gmClassInstance'])    = gmClassInstance;
inputStructure.([prefix, 'gmm_didGmmConverge'])    = didConverge;
inputStructure.([prefix, 'gmm_centroids'])          = gmClassInstance.mu;
inputStructure.([prefix, 'gmm_pointsMembership'])   = cluster(gmClassInstance, pointsToCluster);

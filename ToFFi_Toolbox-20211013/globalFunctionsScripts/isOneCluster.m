function [isOne, prop] = isOneCluster(cfg, X)
%%
% Checks whether data forms single cluster according to the given metric.
% For cosine metric, it calculates the angles between all data points and a
% probe vector. If a distribution of the angle is Gaussian then it is assumed
% that data forms a single cluster. For Euclidean metric, multivariate
% normality test is carried out. If data is Gaussian then it is assumed that
% it forms a single cluster.
% If it happens that probe vector is the symmetry
% axis of the data, then angle distribution will be symmetric to it
% and probably gaussian which can lead to spuriously assuming that
% data forms single cluster. To prevent this, multiple random unit probe
% vectors are used and for each vector we test for normality. If majority
% of the test are in favor of single cluster then we assume data forms a
% single cluster.
%
%% Inputs
% *cfg* - struct with fields:
%
% _metric_ - distance metric. Currently supported: 'cosine' or 'sqEuclidean'.
%
% *X* - double N-by-P matrix. N is the number of observations, and P is the
%       number of variables
%% Outputs
%
% *isOne* - flag; equals 1 if data forms single cluster according to given
%           distance metric (cfg.metric) or 0 if not
%
% *prop* - double; percentage of tests whose answer points to single cluster
%          solution 
%
%%
N       = size(X,1);
nDim    = size(X,2);
nProbes = 1000; % number of tests

switch(cfg.metric)
    case 'cosine'
        % current idea:         
        
        % normality test on an angles distribution 
        x0 =  ones(1,nDim)/sqrt(nDim); % probe unit vector - first probe
        % add rest of the probes 
        x0_2 = rand(nProbes-1,nDim);
        x0_2 = x0_2./sqrt(sum(x0_2.^2, 2));

        X0 = [x0; x0_2];
        T = [];
        for iProbe = 1:nProbes
            x       = X0(iProbe,:);
            phi     = acos((X*x')./sqrt(sum(X.^2, 2)));
            h       = lillietest(phi); % h=0 => normal
            T = [T, ~h];
        end
        prop = sum(T)/nProbes;
        isOne = (prop > 0.5); % test for majority
        
    case 'sqEuclidean'
        % normality test on dat itself
        h = HZmvntest(X); % h=0 => normal
        isOne = ~h; 
        prop = [];
    otherwise
        % give warning
        warning(['Currently, detection of whether data forms a single cluster ' ...
                 'is  not implemented for metrics other than ''cosine'' or ' ...
                 '''euclidean'' ! Number of optimal clusters will be greater ' ...
                 'or equal 2.'])
        prop = 0;
        isOne = 0;
end

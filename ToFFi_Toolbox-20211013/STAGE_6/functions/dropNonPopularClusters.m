function newGmClassInstance = dropNonPopularClusters(gmClassInstance, dropIdx)
%%
% Drops selected clusters from gmdistribution object.
%% Inputs
% *gmClassInstance* - gmdistribution object
%                     (https://www.mathworks.com/help/stats/gmdistribution.html)
% *dropIdx* - double; 1D-array; components indices to be removed.
%% Outputs
% *newGmClassInstance* - gmdistribution object with removed selected components
%                     (https://www.mathworks.com/help/stats/gmdistribution.html)
%%

new_mu = gmClassInstance.mu;
new_mu(dropIdx,:) = [];
new_Sigma = gmClassInstance.Sigma;
new_Sigma(:,:,dropIdx) = [];
new_p = gmClassInstance.PComponents;
new_p(dropIdx) = [];

newGmClassInstance = gmdistribution(new_mu, new_Sigma, new_p);
% NOTE: new_p will be normalized by Matlab, because it needs sum to 1
% (https://www.mathworks.com/help/stats/gmdistribution.html#d120e373845)

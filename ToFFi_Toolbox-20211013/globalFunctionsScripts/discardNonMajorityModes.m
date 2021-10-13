function SF_out = discardNonMajorityModes(SF_in, majN)
%%
% Function that removes spectral modes that are not represented by enough
% number of subjects. It will NOT REMOVE fields in the input SF structure !
% It will add new updated field with suffix in its name.
%% Inputs
% *SF_in* - Spectral Fingerprint structure with fields
%
%                    _lvl2_gmm_centroids_ : [nModes×nFreq double]
%
%             _lvl2_gmm_pointsMembership_ : [nPoints×1 double]
%
%              _lvl2_gmm_gmClassInstance_ : [1×1 gmdistribution]
%
%             _lvl2_gmm_centroidDuration_ : [1×nModes]
%
%          _lvl2_gmm_subjectsContributed_ : {1×nModes cell : [nSubContributedToThisMode×1 double]}
%
%         _lvl2_gmm_nSubjectsPerCentroid_ : [1×nModes double]
%
% *majN* - double positive integer; minimum number of subjects to keep given
%          mode  
%% Outputs
% *SF_out* - Spectral Fingerprint structure with fields
%
%                    _lvl2_gmm_centroids_ : [nModes×nFreq double]
%
%             _lvl2_gmm_pointsMembership_ : [nPoints×1 double]
%
%              _lvl2_gmm_gmClassInstance_ : [1×1 gmdistribution]
%
%             _lvl2_gmm_centroidDuration_ : [1×nModes]
%
%          _lvl2_gmm_subjectsContributed_ : {1×nModes cell : [nSubContributedToThisMode×1 double]}
%
%         _lvl2_gmm_nSubjectsPerCentroid_ : [1×nModes double]
%
% (new fields below)
%
%                  _Maj_lvl2_gmm_MajModesIdx_ :  [1×nMajModes double]
%
%                    _Maj_lvl2_gmm_centroids_ : [nMajModes×nFreq double]
%
%              _Maj_lvl2_gmm_gmClassInstance_ : [1×1 gmdistribution]
%
%             _Maj_lvl2_gmm_centroidDuration_ : [1×nMajModes]
%
%          _Maj_lvl2_gmm_subjectsContributed_ : {1×nMajModes cell : [nSubContributedToThisMode×1 double]}
%
%         _Maj_lvl2_gmm_nSubjectsPerCentroid_ : [1×nMajModes double]
%%
% EXAMINATION
SF_out = SF_in;  % copy
nModes = numel(SF_in.lvl2_gmm_centroidDuration);
numSubPerMode = SF_in.lvl2_gmm_nSubjectsPerCentroid;

% Marking modes to "prune"
pruneModeFlag = zeros(1,nModes);
for iMode = 1:nModes
    if(numSubPerMode(iMode) < majN)
	pruneModeFlag(iMode) = 1;
    end
end
majModesIdx = find(~pruneModeFlag);

% ADDING NEW FIELDS
% Bookkeep modes that has majority
SF_out.Maj_lvl2_gmm_MajModesIdx             = majModesIdx;
SF_out.Maj_lvl2_gmm_centroids               = SF_in.lvl2_gmm_centroids(majModesIdx, :);

% also preprocess gmdistribution
% average gmClassInstance
gmm_in           = SF_in.lvl2_gmm_gmClassInstance;
mu_out           = gmm_in.mu(majModesIdx, :);
Sigma_out        = gmm_in.Sigma(:, :, majModesIdx);
PComponents_out  = gmm_in.PComponents(majModesIdx);
gmm_out                             = gmdistribution(mu_out, Sigma_out, PComponents_out);
SF_out.Maj_lvl2_gmm_gmClassInstance = gmm_out;

% rest of the needed fields
SF_out.Maj_lvl2_gmm_centroidDuration        = SF_in.lvl2_gmm_centroidDuration(majModesIdx);
SF_out.Maj_lvl2_gmm_subjectsContributed     = SF_in.lvl2_gmm_subjectsContributed(majModesIdx);
SF_out.Maj_lvl2_gmm_nSubjectsPerCentroid    = SF_in.lvl2_gmm_nSubjectsPerCentroid(majModesIdx);

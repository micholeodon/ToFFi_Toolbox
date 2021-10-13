function roiFit  = calculateFit(cfg, singleRoiPooledPoints, singleRoiSpectralFingerprint)
%%
% Calculates how well points of given ROI (pooled points aka spectral modes
% from STAGE_3) fits Spectral Fingerprint of another ROI (output from STAGE_5).
%% Inputs
%
% *cfg* - currently not used. Should be empty (i.e. equal []).
%
% *singleRoiPooledPoints* - double 2D-array of spectral modes of given
%                           ROI. Size: N x D, where N is the number of modes
%                           and D is the number of frequencies of interest.
%
% *singleRoiSpectralFingerprint* - struct representing Spectral Fingerprint
%                                  of single brain region. Used fields:
%
% _lvl2_gmm_gmClassInstance_ - object that stores a Gaussian mixture model
%                              (GMM), which is a multivariate distribution
%                              that consists of multivariate Gaussian
%                              distribution components. Further details:
% (https://www.mathworks.com/help/stats/gmdistribution.html)
%
%% Outputs
% *roiFit* - double; real value that quantifies how well given brain region
%            spectral modes fits Spectral Fingerprint of another ROI.
%%

points  = singleRoiPooledPoints;
GmModel = singleRoiSpectralFingerprint.lvl2_gmm_gmClassInstance;

cfg = [];
roiFit  = fitTestRoiPointsToRoi(cfg, points, GmModel);

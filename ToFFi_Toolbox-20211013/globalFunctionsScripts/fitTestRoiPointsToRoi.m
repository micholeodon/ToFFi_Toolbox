function fitTestResult = fitTestRoiPointsToRoi(cfg, points, model)
%%
% Calculate fitness value (currently: negative log-likelihood) for given
% points under given model (currently: gaussian mixture model).
% Currently uses MATLABS _posterior_ routine - see:
% https://www.mathworks.com/help/stats/gmdistribution.posterior.html)
%% Inputs
% *cfg* - currently not used. Should be empty (i.e. equal []).
%
% *points* - double 2D-array of size N x D, where N is the number of
%            points and D is the number of dimensions.
%
% *model* - model for points to be tested against. Currently gaussian mixture
%           model which is a multivariate distribution that consists of
%           multivariate Gaussian distribution components. Further details:
%           (https://www.mathworks.com/help/stats/gmdistribution.html)
%% Outputs
% *fitTestResult* - double; real value that quantifies how well given
%                   *points* fit to the *model*. Currently negative
%                   log-likelihood value.
%%

[posteriorP, nlogl] = posterior(model, points);
fitTestResult       = nlogl; % the lower the better;

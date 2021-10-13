function  clusterTime = computeSingleClusterDuration(cfg, pointsTime, pointsSubjects)
%%
% Gets the amount of time single cluster from single ROI
% Spectral Fingerprint exists in relation to whole recording time.
%
% It assumed that each cluster is a collection of points that each have
% associated duration and "owner" (subject it belongs to). Cluster time is
% computed then as a sum of points' time divided by the number of unique
% subjects that these points belongs to.
%
% NOTE! This procedure can yield cumulative percentages of above 1.00 (or
% 100%) as it was implemented in the original publication
% A. Keitel and J. Gross, “Individual human brain areas can be identified
% from their characteristic spectral activation fingerprints,” PLoS Biol,
% vol. 14, no. 6, p. e1002498, 2016.
%% Inputs
%
% *cfg* - currently not used. Is should be empty, i.e. equals [].
%
% *pointsTime* - double 1D-array with positive real numbers that sum to 1.00
%                or 100 (if you want to express time in percent). Each entry
%                should correspond to duration of single unique point in cluster.
%
% *pointsSubjects* - double 1D-array Each entry
%                    should correspond to subject that "owns" this single
%                    unique point in cluster.
%
%% Outputs
% *clusterTime* - cluster time duration
%%

if(any(pointsTime == 0)) warning('Some points have 0 duration (check pointsTime argument).'); end
if(~isequal(numel(pointsTime), numel(pointsSubjects))) error('Number of points in both input argument does not match !'); end

disp('Computing cluster duration ...')

nPoints = numel(pointsTime);

if(nPoints == 0)
    warning('No points in this cluster ! Check !')
    clusterTime = 0;

else

    totalClusterTime    = sum(pointsTime);
    listUniqueSubjects  = unique(pointsSubjects);
    nUniqueSubjects     = length(listUniqueSubjects);

    if(nUniqueSubjects == 0)
        error('Number of unique subjects is 0 (check pointsSubjects argument).');
    end

    clusterTime = totalClusterTime/nUniqueSubjects;
end

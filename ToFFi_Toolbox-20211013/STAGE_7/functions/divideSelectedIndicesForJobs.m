function indices = divideSelectedIndicesForJobs(jobInfo, selSub)
%%
% Divides set of subjects into non-overlapping subsets to be processed by jobs.
%% Inputs
% *jobInfo* - struct with following fields:
%
% _jobID_ - current job number
%
% _nJobs_ - number of jobs used in this stage (see STAGE_4.sl array
%           configuration)
%
% *selSub* - double; 1D-array with subject indices selected to be divided to
%            subsets and processed by many jobs
%% Outputs
% *indices* - double; 1D-array with subject indices selected to be processed
%             by current job calling this function
%%

if(~isfield(jobInfo, 'jobID')) error('No jobID field in jobInfo argument !'); end
if(~isfield(jobInfo, 'nJobs')) error('No nJobs field in jobInfo argument !'); end

goodSub = selSub;
nGoodSub      = length(goodSub);
nSubPerJob    = ceil(nGoodSub / jobInfo.nJobs);

if(nSubPerJob<1)
    error('Too many jobs declared: would results in less than one subject per worker.');
end

% list of indices for cores (spmd)
[listIndices, ~]  = prepareBatchesIndices(nSubPerJob, nGoodSub);

nJobsThatNeedToWork = length(listIndices);

if(jobInfo.jobID > nJobsThatNeedToWork)
    indices = []; % no work to be done by that job.
else
    indices = goodSub(listIndices{jobInfo.jobID});
end

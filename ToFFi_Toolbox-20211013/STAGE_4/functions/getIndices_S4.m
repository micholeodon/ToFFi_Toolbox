function indices = getIndices_S4(globalConfig, jobInfo)
%%
% Gets ROI indices from globalConfig.goodROI that will be processed
% by the current job function was called on.
%% Inputs
% *globalConfig* - struct; Holds configuration variables common for all
%                  stages. Used fields:
%
% _goodROI_ - double; ROI indices to include in processing
%
% *jobInfo* - struct with following fields:
%
% _jobID_ - current job number
%
% _nJobs_ - number of jobs used in this stage (see STAGE_4.sl array
%           configuration)
%% Outputs
% *indices* - double; 1D-array; ROI indices to include in processing for
%             current job
%%

if(~isfield(jobInfo, 'jobID')) error('No jobID field in jobInfo argument !'); end
if(~isfield(jobInfo, 'nJobs')) error('No nJobs field in jobInfo argument !'); end

nGoodRoi    = length(globalConfig.goodROI);
nRoiPerJob  = ceil(nGoodRoi/jobInfo.nJobs);
[listIndices, ~]     = prepareBatchesIndices(nRoiPerJob, nGoodRoi);

nJobsThatNeedToWork = length(listIndices);

if(jobInfo.jobID > nJobsThatNeedToWork)
	indices = []; % no work to be done by that job
else
	indices = listIndices{jobInfo.jobID};
end

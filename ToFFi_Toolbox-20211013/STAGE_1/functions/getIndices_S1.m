function indices = getIndices_S1(globalConfig, jobInfo);
%%
% Gets subject indices from globalConfig.goodSubjects that will be processed
% by the current job function was called in.
%% Inputs
% *globalConfig* - struct; Holds configuration variables common for all
%                  stages. Used fields:
%
% _goodSubjects_ - double; subject indices to include in processing
%
% *jobInfo* - struct with following fields:
%
% _jobID_ - current job number
%
% _nJobs_ - number of jobs used in this stage (see STAGE_1.sl array
%           configuration)
%% Outputs
% *indices* -  double; 1D-array; subject indices to include in processing for
%              current job
%%

  if(~isfield(jobInfo, 'jobID')) error('No jobID field in jobInfo argument !'); end
  if(~isfield(jobInfo, 'nJobs')) error('No nJobs field in jobInfo argument !'); end

  goodSubjects = globalConfig.goodSubjects;

  nGoodSubjects    = length(goodSubjects);
  nSubPerJob       = ceil(nGoodSubjects / jobInfo.nJobs);

  if(nSubPerJob<1)
    error('Too many jobs declared: would results in less than one subject per worker.');
  end

  % list of indices for cores (spmd)
  [listIndices, ~]     = prepareBatchesIndices(nSubPerJob, nGoodSubjects);

  nJobsThatNeedToWork = length(listIndices);

  if(jobInfo.jobID > nJobsThatNeedToWork)
    indices = []; % no work to be done by that job.
  else
    indices = goodSubjects(listIndices{jobInfo.jobID});
  end

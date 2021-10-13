function maxJobArraySize = calculateMaxJobArraySize(globalConfig)
%%
% Function that calculates maximum number of jobs that can be queued
% relying on numbers found in global configuration (*globalConfig*).
% *globalConfig.maxNumQueuedJobsPerUser* is the number of jobs that single user
% of computer cluster could queue at a time. It is set in configuration
% script and it % should be known by the user (contact computer cluster
% administrator to get that information).
%
% NOTE! You can edit values in line 17 and 18 to suit your needs and limitations.
%%
if(~isfield(globalConfig, 'maxNumQueuedJobsPerUser')) error('Missing field maxNumQueuedJobsPerUser in global config !'); end
if(~isfield(globalConfig, 'maxNumSpmdWorkers')) error('Missing field maxNumSpmdWorkers in global config !'); end


% You can edit these parameters to suit your analysis
numOfStagesWithOneJob = 7; % enter here how many stages will be run using one job
numOfStagesWithMaxNumOfJobs = 4; % enter here how many stages will be run
				                 % using maximum number of jobs

A = globalConfig.maxNumQueuedJobsPerUser;
B = globalConfig.maxNumSpmdWorkers;

if(A<(numOfStagesWithOneJob+numOfStagesWithMaxNumOfJobs))
    maxJobArraySize = 1;
else
    % We here assume that
    maxJobArraySize = floor( (A-numOfStagesWithOneJob) / numOfStagesWithMaxNumOfJobs );
end


if(maxJobArraySize > A)
    error('maxJobArraySize > maxNumQueuedJobsPerUser : Check parallel computation parameters in global config !');
end

if(maxJobArraySize <= 0)

    errorMsg = ['maxJobArraySize <= 0 ! To fix that do one of these things:' ...
    '\n- reduce number of stages demanding single job', ...
    '\n- reduce number of stages demanding more than one (maxJobArraySize) job', ...
    '\n- increase number of permitted queued jobs per user (ask admin of cluster computer)'];

    error(sprintf(errorMsg));
end


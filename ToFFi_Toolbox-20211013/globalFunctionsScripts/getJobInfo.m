function jobInfo = getJobInfo()
%%
% Function outputs individual job number and total number of jobs in a form
% of a struct. When performing parallel computation (many jobs at the same
% time) withing SLURM queueing system.
%%
% Get job ID
% enter names for environmental variables that store:
jobID_s = getenv('SLURM_ARRAY_TASK_ID'); % job number
nJobs_s = getenv('SLURM_ARRAY_TASK_COUNT'); % total number of jobs running

if(isempty(jobID_s))
    jobID_s = '1';
end
jobInfo.jobID = str2double(jobID_s);

if(isempty(nJobs_s))
    nJobs_s = '1';
end
jobInfo.nJobs = str2double(nJobs_s);

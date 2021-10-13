%%
STAGE_NAME = 'STAGE_5'

tic

%% init that can't be in other place. Order is important !
Init_Script

%%
[list_data, isMissingData] = checkStageDataPresence(CFG.(STAGE_NAME));

%% RNG_1 Set root rng and save
[rootTestVec, ~] = setRngSerialSeed(CFG.(STAGE_NAME).rngSeed);
saveRngSerialInfo('../output/rngRoot', 0, rootTestVec);

switch MODE
    case 'serial'

      CORE(CFG, CFG.Global.goodROI, []);

      time = toc;
      save('../output/time.mat', 'time');

    case 'parallel'
      run init_parallel_env

      jobInfo = getJobInfo;

      % RNG_2.1 Set separate seed for each job
      jobSeeds = generateSeeds(jobInfo.nJobs);
      [jobTestVec, ~] = setRngSerialSeed(jobSeeds(jobInfo.jobID));

      PROCESS_ROI_PARALLEL

      % RNG_2.2 Save rng of each job
      saveRngSerialInfo('../output/rngJob', jobInfo.jobID, jobTestVec);

      time = toc;
      jobInfo = getJobInfo();
      save(['../output/time_job_', num2str(jobInfo.jobID) , '.mat'], 'time');

    otherwise
      error('ERROR: Wrong value of MODE !');

end

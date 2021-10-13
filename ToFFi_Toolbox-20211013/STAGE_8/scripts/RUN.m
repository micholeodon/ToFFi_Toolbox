%%
STAGE_NAME = 'STAGE_8'

tic

%% init that can't be in other place. Order is important !
Init_Script

%%
[list_data, isMissingData] = checkStageDataPresence(CFG.(STAGE_NAME));

if(isMissingData)
    error(['ERROR in ', STAGE_NAME, ' : Data is missing !']);
end

%% RNG_1 Set root rng and save
[rootTestVec, ~] = setRngSerialSeed(CFG.(STAGE_NAME).rngSeed);
saveRngSerialInfo('../output/rngRoot', 0, rootTestVec);

switch MODE
    case 'serial'

      CORE(CFG, MODE, list_data, []);

	time = toc;
	save('../output/time.mat', 'time');


  case 'parallel' % Warning ! Runs on single job only !

	run init_parallel_env
	jobInfo = getJobInfo();

	CORE(CFG, MODE, list_data, jobInfo);

	closeParpool
	time = toc;
	save(['../output/time_job_', num2str(jobInfo.jobID) , '.mat'], 'time');

    otherwise
	error('ERROR: Wrong value of MODE !');
end

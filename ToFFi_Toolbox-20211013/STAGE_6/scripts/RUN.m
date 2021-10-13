%%
STAGE_NAME = 'STAGE_6'

tic
%% init that can't be in other place. Order is important !
Init_Script

%%
[stageData.pooledClusters, stageData.nClustersPerRoi] = prepareData_Stage6(CFG);
nReps           = CFG.(STAGE_NAME).CV.nRepetitions;

%% RNG_1 Set root rng and save
[rootTestVec, ~] = setRngSerialSeed(CFG.(STAGE_NAME).rngSeed);
saveRngSerialInfo('../output/rngRoot', 0, rootTestVec);

switch MODE
  case 'serial'

    for iRep = 1:nReps
	disp(['REP = ', num2str(iRep)])

	CORE(CFG, iRep, stageData, MODE)

    end % iRep

    time = toc;
    save('../output/time.mat', 'time');

  case 'parallel'
    run init_parallel_env

    [repsIndicesList, nBatches] = prepareBatchesIndices(CFG.Global.maxNumSpmdWorkers, ...
						      CFG.STAGE_6.CV.nRepetitions);

    % RNG_2.1 Generate unique seed for each batch
    batchSeeds = generateSeeds(nBatches);

    for iBatch = 1:nBatches
        processBatch_Script
    end % iBatch

    closeParpool

    time = toc;
    save('../output/time.mat', 'time');

  otherwise
    error('ERROR: Wrong value of MODE !');
end

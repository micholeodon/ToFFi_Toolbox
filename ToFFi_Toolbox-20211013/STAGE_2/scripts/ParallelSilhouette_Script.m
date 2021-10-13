[iterationsIndicesList, nBatches] = prepareBatchesIndices(CFG.Global.maxNumSpmdWorkers, CFG.STAGE_2.NumClustEval_nIterations);

% RNG_3.1 Generate unique seed for each batch
batchSeeds = generateSeeds(nBatches);

for iBatch = 1:nBatches
    indices             = iterationsIndicesList{iBatch};
    nWorkersInThisBatch = length(indices); % list of indices can have unequal lengths

    spmd(nWorkersInThisBatch)
	workerID = labindex;

	% RNG_3.2 Set worker rng stream
	spmdTestVec = ...
	    setRngSpmdSeed(batchSeeds(iBatch), workerID, nWorkersInThisBatch);

	% test random numbers (see in .log)
	tmp = rng;
	disp(['workerID=', num2str(workerID), ...
	      ';rng.Seed=', num2str(tmp.Seed), ...
	      ';rand=', num2str(rand)])

	disp(['Num. Clust. Evaluation: Iteration ', num2str(indices(workerID)), ' / ', num2str(CFG.STAGE_2.NumClustEval_nIterations), ' ...' ]);

	evalutationObject_WORKERS = evalclusters( dataToTest, ...
						  CFG.STAGE_2.NumClustEval_methodName, ...
						  CFG.STAGE_2.NumClustEval_criterionType, ...
						  'klist',    CFG.STAGE_2.NumClustEval_kList, ...
						  'Distance', CFG.STAGE_2.NumClustEval_distanceMetric);

    end % spmd (% NumClustEval_nIterations)

    % extract from Composites
    for iWorker = 1:nWorkersInThisBatch
	evalutationObject = evalutationObject_WORKERS{iWorker};

	clusteringEvaluation.optNumClustersAllIter(indices(iWorker)) = evalutationObject.OptimalK;
	idx = find(evalutationObject.InspectedK == evalutationObject.OptimalK);
	clusteringEvaluation.criterionValues(indices(iWorker))       = evalutationObject.CriterionValues(idx);
    end % iWorker

    % RNG_3.3 Save rng of each batch
    saveRngSpmdInfo('../output/rngSpmd', jobInfo.jobID, iBatch, spmdTestVec)
    clear workerID spmdTestVec tmp evalutationObject_WORKERS
    % to clear the context so next time I can have different number of workers (see: https://www.mathworks.com/matlabcentral/answers/223939-how-to-specify-the-number-of-labs-in-smpd)

end % iBatch (% NumClustEval_nIterations)

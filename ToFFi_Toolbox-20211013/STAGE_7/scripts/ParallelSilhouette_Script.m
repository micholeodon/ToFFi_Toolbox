[batchesIndicesSets, nBatches]  = prepareBatchesIndices(CFG.Global.maxNumSpmdWorkers, nIterations);
batchInfo.nBatches              = nBatches;
batchInfo.indicesSets           = batchesIndicesSets;

% RNG_3.2 Generate unique seed for each batch
batchSeeds = generateSeeds(nBatches);

for iBatch = 1:nBatches
    indices             = batchesIndicesSets{iBatch}; % subject indices in subIndicesInThisJob
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

	iIteration = indices(workerID);
	disp(['Num. Clust. Evaluation: Iteration ', num2str(iIteration), ' / ', num2str(nIterations), ' ...' ]);

	evaluationObject_WORKERS = evalclusters( dataToTest, ...
						 CFG.(STAGE_NAME).NumClustEval_methodName, ...
						 CFG.(STAGE_NAME).NumClustEval_criterionType, ...
						 'klist',    CFG.(STAGE_NAME).NumClustEval_kList, ...
						 'Distance', CFG.(STAGE_NAME).NumClustEval_distanceMetric);
    end % spmd

    % extract from Composites
    for iWorker = 1:nWorkersInThisBatch
	evaluationObject = evaluationObject_WORKERS{iWorker};

	clusteringEvaluation.optNumClustersAllIter(indices(iWorker)) = evaluationObject.OptimalK;
	idx = find(evaluationObject.InspectedK == evaluationObject.OptimalK);
	clusteringEvaluation.criterionValues(indices(iWorker))       = evaluationObject.CriterionValues(idx);
    end % iWorker

    % RNG_2.3 Save rng of each batch
    jobID = data.jobInfo.jobID;
    saveRngSpmdInfo('../output/rngSpmd', jobID, iBatch, spmdTestVec)

    % clear composites
    D = whos();
    D = D(arrayfun(@(d) strcmp(d.class,'Composite'),D));
    clear(D.name)
    % to clear the context so next time I can have different number of workers (see: https://www.mathworks.com/matlabcentral/answers/223939-how-to-specify-the-number-of-labs-in-smpd)

end % iBatch

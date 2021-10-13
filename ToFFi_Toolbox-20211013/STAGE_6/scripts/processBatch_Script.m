indices             = repsIndicesList{iBatch};
nWorkersInThisBatch = length(indices); % list of indices can have unequal lengths

spmd(nWorkersInThisBatch)
    workerID = labindex;

    % RNG_2.2 Set worker rng stream
    [spmdTestVec, ~] = ...
	setRngSpmdSeed(batchSeeds(iBatch), workerID, nWorkersInThisBatch);

    iRep = indices(workerID);
    disp(['REP = ', num2str(iRep)])

    % test random numbers (see in .log)
    tmp = rng;
    disp(['workerID=', num2str(workerID), ...
	  ';rng.Seed=', num2str(tmp.Seed), ...
	  ';rand=', num2str(rand)])

    CORE(CFG, iRep, stageData, MODE)
    disp('Rep done.')
end % spmd

% RNG_2.3 Save rng of each batch
jobID = 1;
saveRngSpmdInfo('../output/rngSpmd', jobID, iBatch, spmdTestVec)
clear iSub spmdTestVec spmdStream
clear workerID iRep tmp
% to clear the context so next time I can have different number of workers (see: https://www.mathworks.com/matlabcentral/answers/223939-how-to-specify-the-number-of-labs-in-smpd)

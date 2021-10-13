prepareRoiBatches_Script

% RNG_3.1 Generate unique seed for each batch
batchSeeds = generateSeeds(nBatches);

for iBatch = 1:nBatches
    batchInfo.iBatch         = iBatch;
    roiIndicesInThisBatch    = roiIndicesInThisJob(batchesIndicesSets{iBatch});
    nRoiInThisBatch          = length(roiIndicesInThisBatch);

    spmd(nRoiInThisBatch)
        workerID = labindex;

        % RNG_3.2 Set worker rng stream
        spmdTestVec  = ...
            setRngSpmdSeed(batchSeeds(iBatch), workerID, nRoiInThisBatch);

        % display rng state
        tmp = rng;
        disp(['workerID=', num2str(labindex), ...
              ';rng.Seed=', num2str(tmp.Seed), ...
              ';rand=', num2str(rand)])

        if(workerID <= nRoiInThisBatch)
            iROI = roiIndicesInThisBatch(workerID);
            CORE(CFG, iROI, jobInfo);
        end
    end % spmd

    % RNG_3.3 Save rng of each batch
    saveRngSpmdInfo('../output/rngSpmd', jobInfo.jobID, iBatch, spmdTestVec)
    clear spmdTestVec spmdStream
    clear workerID iROI tmp
end
closeParpool

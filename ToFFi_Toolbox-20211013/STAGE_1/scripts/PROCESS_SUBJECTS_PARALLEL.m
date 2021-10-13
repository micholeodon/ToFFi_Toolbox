prepareSubjectBatches_Script

% RNG_3.1 Generate unique seed for each batch
batchSeeds = generateSeeds(nBatches);

for iBatch = 1:nBatches

    batchInfo.iBatch         = iBatch;
    subIndicesInThisBatch    = subjectIndicesInThisJob(batchesIndicesSets{iBatch});
    nSubInThisBatch   = length(subIndicesInThisBatch);

    spmd(nSubInThisBatch)
        % RNG_3.2 Set worker rng stream
        [spmdTestVec, ~] = ...
            setRngSpmdSeed(batchSeeds(iBatch), labindex, nSubInThisBatch);

        disp(['LAB: ', num2str(labindex)])
        if(labindex <= nSubInThisJob)
            iSub = subIndicesInThisBatch(labindex);
            disp(['Starting CORE: JOB=', num2str(jobInfo.jobID), ' | BATCH=', num2str(iBatch), ' | WORKER=', num2str(labindex), ' ...'])
            CORE(CFG, iSub, nSubTotal);
            disp(['Finished CORE: JOB=', num2str(jobInfo.jobID), ' | BATCH=', num2str(iBatch), ' | WORKER=', num2str(labindex), ' ...'])
        end
    end


    % RNG_3.3 Save rng of each batch
    saveRngSpmdInfo('../output/rngSpmd', jobInfo.jobID, iBatch, spmdTestVec)
    clear iSub spmdTestVec spmdStream
end

closeParpool

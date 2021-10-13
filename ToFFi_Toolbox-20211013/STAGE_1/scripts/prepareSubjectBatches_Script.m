subjectIndicesInThisJob = getIndices_S1(CFG.Global, jobInfo);
nSubInThisJob = length(subjectIndicesInThisJob);
nSubTotal     = length(CFG.Global.goodSubjects);

[batchesIndicesSets, nBatches]  = prepareBatchesIndices(CFG.Global.maxNumSpmdWorkers, nSubInThisJob);
batchInfo.nBatches              = nBatches;
batchInfo.indicesSets           = batchesIndicesSets;

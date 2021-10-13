roiIndicesInThisJob   = getIndices_S5(CFG.Global, jobInfo);
nRoiInThisJob   = length(roiIndicesInThisJob);
nRoiTotal       = length(CFG.Global.goodROI);

[batchesIndicesSets, nBatches]  = prepareBatchesIndices(CFG.Global.maxNumSpmdWorkers, nRoiInThisJob);
batchInfo.nBatches              = nBatches;
batchInfo.indicesSets           = batchesIndicesSets;

function saveRngSpmdInfo(savePathAndFilename, iJob, iBatch, testVecComposite)
%%
% Function to save test numbers generated by the random number generator
% (numbers stored in testVec) - version to be used when doing parallel
% computations.
%%

nWorkers = numel(testVecComposite);

spmdRngInfo.iJob   = iJob;
rngSpmdInfo.iBatch = iBatch;
rngSpmdInfo.nWorkers = nWorkers;

for iWorker = 1:nWorkers
    rngSpmdInfo.testVec(iWorker,:) = testVecComposite{iWorker};
end

suffix = ['_job', num2str(iJob), '_batch', num2str(iBatch)];
s_path = [savePathAndFilename, suffix, '.mat'];
s_path = fixPath(s_path);
save(s_path, 'rngSpmdInfo')

selSub = CFG.Global.goodSubjects;
subIndicesInThisJob   = divideSelectedIndicesForJobs(jobInfo, selSub) % good subjects
nSubInThisJob   = length(subIndicesInThisJob);

for iSub = subIndicesInThisJob
    t0 = toc;
    CORE(CFG, iSub, MODE, jobInfo);
    tf = toc;
    time = tf-t0;
    save(['../output/time_job', num2str(jobInfo.jobID), ...
	  '_sub', num2str(iSub) '.mat'], 'time');
end

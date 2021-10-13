indCV.CV_avg.acc_avg_acrossReps = mean(acc_reps, 1);
indCV.CV_avg.acc_std_acrossReps = std(acc_reps, 0, 1);
indCV.CV_avg.mr_avg_acrossReps  = mean(mr_reps, 1);
indCV.CV_avg.mr_std_acrossReps  = std(mr_reps, 0, 1);

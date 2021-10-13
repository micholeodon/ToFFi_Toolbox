% script
partFile = [notIntegratedFolder, 'CV_iRep1.mat'];
load(partFile)

CV = initArrayOfStruct(nReps, CV_singleRep);
clear CV_singleRep

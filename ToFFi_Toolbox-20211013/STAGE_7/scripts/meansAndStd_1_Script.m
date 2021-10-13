CV_singleRep(iRep).accRoiMeanFolds                      = zeros(1, nRoiAtlas);
CV_singleRep(iRep).accRoiMeanFolds(goodROI)             = mean(acc_folds, 1);

CV_singleRep(iRep).acc_std_RoiStdFolds                  = zeros(1, nRoiAtlas);
CV_singleRep(iRep).acc_std_RoiStdFolds(goodROI)         = std(acc_folds, 0, 1);

CV_singleRep(iRep).meanRankRoiMeanFolds                 = zeros(1, nRoiAtlas);
CV_singleRep(iRep).meanRankRoiMeanFolds(goodROI)        = mean(mr_folds, 1);

CV_singleRep(iRep).meanRank_std_RoiStdFolds             = zeros(1, nRoiAtlas);
CV_singleRep(iRep).meanRank_std_RoiStdFolds(goodROI)    = std(mr_folds, 0, 1);
CV_singleRep(iRep).NLL = NLL_singleRep;

fname = [CFG.(STAGE_NAME).inputDataFolder{1}, ...
	     '/Sub_', num2str(iSub), '/' ...
	     CFG.(STAGE_NAME).dataNamesList{1}, ...
	     '_', num2str(iSub), '.mat'];
load(fname)

points = [];
groups = [];

for iGoodROI = 1:nGoodROI
    iROI = goodROI(iGoodROI);

    X = singleSubjectPowerData{iROI}.normalizedPowerSpectrum_Trials;
    n = size(X,1);
    points = [points; X];
    groups = [groups; iROI*ones(n,1)];
end

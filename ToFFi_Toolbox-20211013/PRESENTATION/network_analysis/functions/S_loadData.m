% Subroutine of networksPlot.m

disp 'Data loading ...'
cfg.srcDir = fixPath(cfg.srcDir);
CFG_file = [cfg.srcDir, '/STAGE_8/output/CFG.mat'];
if(~exist(CFG_file, 'file'))
    error(['ERROR! File ', CFG_file, ' not exist!'])
else
    load(CFG_file)
end

data_file = [cfg.srcDir, '/STAGE_8/output/networkAnalysisResult.mat'];
if(~exist(data_file, 'file'))
    error(['ERROR! File ', data_file, ' not exist!'])
else
    load(data_file)
end

disp 'Data loaded!'
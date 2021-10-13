% load Fieldtrip Toolbox (subroutine of showOn3dBrain)

load ../../STAGE_8/output/CFG.mat
fieldtripPath = CFG.Global.fieldtripPath;
addpath(fieldtripPath)
ft_defaults;
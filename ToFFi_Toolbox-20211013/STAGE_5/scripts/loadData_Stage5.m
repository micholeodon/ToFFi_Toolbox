% script
if(~exist('STAGE_NAME', 'var')) error('Add STAGE_NAME = ''STAGE_? '' line in the CORE.m file !'); end

disp('Loading data ...')

dataName_1 = CFG.(STAGE_NAME).dataNamesList{1};
dataName_2 = CFG.(STAGE_NAME).dataNamesList{2};
load([CFG.(STAGE_NAME).inputDataFolder{1}, dataName_1]);
load([CFG.(STAGE_NAME).inputDataFolder{2}, dataName_2]);

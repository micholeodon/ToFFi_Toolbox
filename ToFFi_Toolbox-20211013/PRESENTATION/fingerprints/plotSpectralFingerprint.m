% script plotting the result of the STAGE 5

clear; close all; clc;

addpath ./functions
addpath ../common_functions
addpath ../../ext_tools/vline_hline

%% SETTINGS %% (user edits this section)

cfg = [];
% path to repository root '../../' or path to selected backup directory
cfg.SRC_DIR     = '../../';
% [] (to select all the good ROIs) or vector to select a ROIs subset in given order
cfg.ROI_LIST    = [];  
% 'on' (display figures) or 'off' (do not display figures)
cfg.FIG_VISIBLE = 'on';          
% 'y' (save figure as .fig and .png ) or 'n' (do not save)
cfg.FIG_SAVE    = 'y';
% dot radius on the scatter plot (defaults 20)
cfg.DOT_SIZE    = 40;  
% value between 0 and 1 ; Adjusts opacity of the std shaded error bars 
cfg.STD_OPACITY = 0.2;
% adjust plot lines width (default 1)
cfg.LINE_WIDTH = 5;
% 1 - show "[frequency, power]" labels near spectral modes' peaks, 0 - do
% not show peak labels
cfg.LABEL_PEAKS = 1;

%% PLOT & SAVE %%

cfg.SRC_DIR = fixPath(cfg.SRC_DIR);

CFG_file = [cfg.SRC_DIR, '/STAGE_5/output/CFG.mat'];
if(~exist(CFG_file, 'file'))
    error(['ERROR! File ', CFG_file, ' not exist!'])
else
    load(CFG_file)
end

switch cfg.FIG_SAVE
    case 'y'
        createOutputDir
    case 'n'
    otherwise
        error('ERROR! Wrong value of cfg.FIG_SAVE !')
end

goodRoi = CFG.Global.goodROI;
if(~isempty(cfg.ROI_LIST))
    roiList = cfg.ROI_LIST;
else
    roiList = goodRoi;
end

for iRoi = roiList
    
    sfFile = [cfg.SRC_DIR, '/STAGE_5/output/', 'singleRoiSpectralFingerprint_iROI', ...
        num2str(iRoi),'.mat'];
    
    if(exist(sfFile, 'file'))
        plotSF(cfg, iRoi)
    else
        warning(['File ', sfFile, ' not exist! Skipping.'])
    end
    
    switch cfg.FIG_SAVE
        case 'y'
            fname = ['SF_ROI_', num2str(iRoi)];
            savefig([outDir, fname, '.fig'])
            saveas(gcf, [outDir, fname, '.png'])
        case 'n'
        otherwise
            error('ERROR! Wrong value of cfg.FIG_SAVE !')
    end
end

disp DONE!
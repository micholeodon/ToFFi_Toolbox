% script plotting the result of the STAGE 6

close all;
clear; clc;

addpath ./functions
addpath ../common_functions

%% SETTINGS (user edits this section)
cfg = [];
% path to repository root '../../' or path to selected backup directory
cfg.srcDir     = '../../';
% 'mr' (bar plot with mean ranks), 'acc' (bar plot with with accuracy of identification)
cfg.measure     = 'acc';    
% 'folds' (show averages across folds; plots several bar plots), 'reps' (show averages across CV repetitions; plots single bar plot)
cfg.meanAcross  = 'folds';  
% 'number' to display ROIs' indices or 'name' to display full ROIs' names
cfg.labelMode   = 'name';   
cfg.barColor    = [0 0 1];  % RGB values - 3 x 0.00-1.00 , ex. [1.0 0.2 0.7]
cfg.std         = 'y';      % 'y' (display error bars), 'n' (hide error bars)
% [] (to select all the good ROIs) or vector to select a ROIs subset in given order
cfg.roi         = [6, 25, 54, 89, 67, 102, 70, 105];       
cfg.figVisible  = 'on';     % 'on' (display figures) or 'off' (do not display figures)
cfg.figSave     = 'y';      % 'y' (save figure as .fig and .png) or 'n' (do not save figures)
% 'y' (stretch figure to fill entire screen; useful for displaying many ROIs) or 'n' (default figure window size)
cfg.fullScreen  = 'n';      

%% load
disp 'Data loading ...'

cfg.srcDir = fixPath(cfg.srcDir);
CFG_file = [cfg.srcDir, '/STAGE_6/output/CFG.mat'];
if(~exist(CFG_file, 'file'))
    error(['ERROR! File ', CFG_file, ' not exist!'])
else
    load(CFG_file)
end

data_file = [cfg.srcDir, '/STAGE_6/output/classificationResult.mat'];
if(~exist(data_file, 'file'))
    error(['ERROR! File ', data_file, ' not exist!'])
else
    load(data_file)
end

disp 'Data loaded!'
%% calc
disp 'Calculating ...'

atlasLabels = CFG.Global.sourceAtlasAndSourceModel.sourceAtlas(1).tissuelabel;
goodRoi = CFG.Global.goodROI;
goodRoiLabels = atlasLabels(goodRoi);

if(~isempty(cfg.roi))
    roiList = cfg.roi;
    labels = atlasLabels(cfg.roi);
else
    roiList = goodRoi;
    labels = goodRoiLabels;
end

switch cfg.meanAcross
    case 'reps'
        
        switch cfg.measure
            case 'acc'
                y = classificationResult.accPerRoiMeanReps(roiList);
                e = classificationResult.acc_std_PerRoiStdReps(roiList);
            case 'mr'
                y = classificationResult.meanRankPerRoiMeanReps(roiList);
                e = classificationResult.meanRank_std_PerRoiStdReps(roiList);
            otherwise
                error('ERROR! Wrong value of cfg.measure !')
        end
        Y = y;
        E = e;
        
    case 'folds'
        Y = [];
        E = [];
        nRep = classificationResult.nReps;
        for iRep = 1:nRep
            switch cfg.measure
                case 'acc'
                    y = classificationResult.CV_reps(iRep).accRoiMeanFolds(roiList);
                    e = classificationResult.CV_reps(iRep).acc_std_RoiStdFolds(roiList);
                case 'mr'
                    y = classificationResult.CV_reps(iRep).meanRankRoiMeanFolds(roiList);
                    e = classificationResult.CV_reps(iRep).meanRank_std_RoiStdFolds(roiList);
                otherwise
                    error('ERROR! Wrong value of cfg.measure !')
            end
            % aggregate
            Y = [Y;y];
            E = [E;e];
        end
        
    otherwise
        error('ERROR! Wrong value of cfg.meanAcross !')
end

disp 'Calculating done!'

%% plot & format
disp 'Plotting ...'

switch cfg.meanAcross
    case 'reps'
        nFig = 1;
        tit_mean = '(mean across repetitions)';
    case 'folds'
        nFig = nRep;
        tit_mean = '(mean across folds)';
    otherwise
        error('ERROR! Wrong value of cfg.meanAcross !')
end

for iFig = 1:nFig
    
    switch cfg.fullScreen 
        case 'y'
            h(iFig) = figure('Units', 'Normalized', 'OuterPosition', [0 0 1 1], 'Visible', cfg.figVisible);
        case 'n'
            h(iFig) = figure('Visible', cfg.figVisible);
        otherwise
            error('ERROR! Wrong value of cfg.fullScreen !')
    end
    y = Y(iFig,:);
    e = E(iFig,:);
    
    switch cfg.measure
        case 'acc'
            minval = 0;
            maxval = 1;
            y_lim = [0 1];
            tit_measure = 'ROI Identification Accuracy';
        case 'mr'
            minval = 1;
            maxval = inf;
            y_lim = [min(y) max(y)];
            tit_measure = 'ROI Identification Mean Rank';
        otherwise
            error('ERROR! Wrong value of cfg.measure !')
    end
    
    % main bars
    bar(y, 'FaceColor', cfg.barColor)
    ylim(y_lim)
    
    % chopped err bars not to exceed limits
    switch(cfg.std)
        case 'y'
            hold on
            ex_l = max(0, minval - (y-e));
            ex_u = max(0, (y+e) - maxval);
            err_l = e - ex_l;
            err_u = e - ex_u;
            errorbar(1:numel(roiList), y, err_l, err_u, 'k.', 'LineWidth', 1.5);
            hold off
        case 'n'
        otherwise
            error('ERROR! Wrong value of cfg.std !')
    end
    
    grid on
    ylabel(cfg.measure)
    xlabel 'ROI'
    switch cfg.meanAcross
        case 'reps'
            tit_last = '';
        case 'folds'
            iRep = iFig;
            tit_last = ['Repetition=', num2str(iRep)];
        otherwise
            error('ERROR! Wrong value of cfg.meanAcross !')
    end
    title({tit_measure, tit_mean, tit_last})
    
    switch cfg.labelMode
        case 'number'
            xticks(1:numel(roiList));
            xlim([0.5 numel(roiList)+0.5])
            xticklabels(roiList);
            xtickangle(45)
        case 'name'
            xticks(1:numel(roiList));
            xlim([0.5 numel(roiList)+0.5])
            xticklabels(labels);
            xtickangle(45)
            set(gca, 'TickLabelInterpreter', 'none') 
        otherwise
            error('ERROR! Wrong value of cfg.labelMode !')
    end
end

disp 'Plotting done!'

%% save
switch cfg.figSave
    case 'y'
        disp 'Saving ...'
        createOutputDir
        
        for iFig = 1:nFig
            fname = [cfg.measure, '_', cfg.meanAcross];
            if(nFig>1)
                fname = [fname, '_', num2str(iFig)];
            end
            
            savefig(h(iFig), [outDir, fname, '.fig'])
            saveas(h(iFig), [outDir, fname, '.png'])
        end
        disp 'Saving done!'
    case 'n'
    otherwise
        error('ERROR! Wrong value of cfg.figSave !')
end
%%
disp 'ALL DONE!'


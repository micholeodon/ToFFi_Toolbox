% script plotting the result of the STAGE 6

close all;
clear; clc;

addpath ./functions
addpath ../common_functions

%% SETTINGS (user edits this section)
cfg = [];
% path to repository root '../../' or path to selected backup directory
cfg.srcDir      = '../../';
cfg.labelMode   = 'name';   % 'number', 'name'
% [] (to select all the good ROIs) or vector to select a ROIs subset in given order
cfg.roi         = [6, 25, 54, 89, 67, 102, 70, 105];   
cfg.repRange    = 1:1;      % range of repetitions to consider, e.g. 1:100
cfg.foldRange   = 1:10;     % range of CV folds to consider, e.g. 1:10
cfg.percent     = 0;        % 1 or 0; show results in percents 
cfg.figVisible  = 'on';     % 'on' (display figures) or 'off' (do not display figures)
cfg.figSave     = 'y';      % 'y' (save figure as .fig and .png ) or 'n' (do not save figures)
cfg.fontSize    = 14;
%% load
disp 'Data loading ...'

cfg.srcDir = fixPath(cfg.srcDir);
CFG_file = [cfg.srcDir, '/STAGE_6/output/CFG.mat'];
if(~exist(CFG_file, 'file'))
    error(['ERROR! File ', CFG_file, ' not exist!'])
else
    load(CFG_file)
end

data_file = [cfg.srcDir, '/STAGE_6/output/NLOGL.mat'];
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
nGoodRoi = numel(goodRoi);
% maxRank - number of best ROIs taken into account (i.e. 3 values from row with least nlogl value)
maxRank  = 1; 

if(~isempty(cfg.roi))
    roiList = cfg.roi;
    labels = atlasLabels(cfg.roi);
else
    roiList = goodRoi;
    labels = goodRoiLabels;
end

ROI_count = zeros(nGoodRoi, nGoodRoi);

% count
for iGoodROI = 1:nGoodRoi
    nGuessesPerValRoi = 0;
    for iRep = cfg.repRange
        for iFold = cfg.foldRange

            L_slice = NLOGL.Reps(iRep).Folds(iFold).nLogL(iGoodROI, :, :);
            L = permute(L_slice, [3 2 1]); % sub x ROI model
           

            % counting
            for iRow = 1:size(L,1) % each row is for another subject
                disp(['ROI=', num2str(iGoodROI), ' REP=', num2str(iRep), ...
                     ' FOLD=', num2str(iFold), ' row=' num2str(iRow)])
                l_row = L(iRow,:);
                r_row = tiedrank(l_row);

                for rk = 1:maxRank
                    jGoodROI = find(r_row == rk);

                    if numel(jGoodROI) > 1
                        error('ERROR ! Found more than 1 ROI with same the rank ! This is very uncommon !')
                    end

                    ROI_count(iGoodROI, jGoodROI) = ROI_count(iGoodROI, jGoodROI) + 1;
                    nGuessesPerValRoi = nGuessesPerValRoi + 1;
                end % rk

            end % iRow

        end % iFold
    end % iRep
end % iROI

ROI_percent_count = ROI_count/nGuessesPerValRoi * 100;

disp 'Calculating done!'

%% plot & format
disp 'Plotting ...'

% figure
img = figure('Units','Normalized','OuterPosition', [0 0 0.6 1], 'Visible', 'on');

idx = arrayfun(@(x) find(ismember(goodRoi, x)), roiList);

if cfg.percent   
    imagesc(ROI_percent_count(idx, idx))
    title({'Percent of hits ROI is recognized as other ROI', ...
        ['REPS=', num2str(cfg.repRange(1)), ':', num2str(cfg.repRange(end))], ...
        [' FOLDS=', num2str(cfg.foldRange(1)), ':', num2str(cfg.foldRange(end))]})
    
    cmap = [autumn(5); flipud(summer(5))];
    colormap(cmap)
    set(gca, 'CLim', [0 100])
else
    
    imagesc(ROI_count(idx, idx))
    title({'Number of hits ROI is recognized as other ROI', ...
    ['REPS=', num2str(cfg.repRange(1)), ':', num2str(cfg.repRange(end))], ...
    [' FOLDS=', num2str(cfg.foldRange(1)), ':', num2str(cfg.foldRange(end))]})

end

xticks(1:numel(idx)); yticks(1:numel(idx));
switch cfg.labelMode
    case 'number'
        xticklabels(roiList); yticklabels(roiList);
        xtickangle(45);
    case 'name'
        xticklabels(labels); yticklabels(labels);
        xtickangle(90); 
    otherwise
        error('ERROR! Wrong value of cfg.labelMode !')
end

set(gca, 'TickLabelInterpreter', 'none')
set(gca,'YDir', 'normal')
set(gca,'FontSize', cfg.fontSize)
ylabel 'ROI (validation points)'
xlabel 'ROI (trained model)'
grid on
colorbar

disp 'Plotting done!'

%% save
switch cfg.figSave
    case 'y'
        disp 'Saving ...'
        createOutputDir
       
        fname = 'grHitMatrix';
        
        if(cfg.percent)
            fname = [fname, '_percent'];
        end
       
        savefig(img, [outDir, fname, '.fig'])
        saveas(img, [outDir, fname, '.png'])
        
        disp 'Saving done!'
    case 'n'
    otherwise
        error('ERROR! Wrong value of cfg.figSave !')
end
%%
disp 'ALL DONE!'

function plotIF(cfg, iSub, iRoi)
% cfg - contains field SRC_DIR (the directory with STAGE_5/output directories)
% and DOT_SIZE (radius of the dots to be plotted on scatterplots)
% iSub - subject number
% iRoi - roi index

inputFolder = [cfg.SRC_DIR, '/STAGE_2/output/'];
load([inputFolder, 'CFG.mat'])
ifFile = [cfg.SRC_DIR, '/STAGE_2/output/','Sub_', num2str(iSub), '/individualFingerprint_', ...
            num2str(iSub),'.mat'];
load(ifFile)

IF          = individualFingerprint;
roiLabel    = IF.tissuelabels{iRoi};
nModes      = size(IF.spectralModes{iRoi}, 1);
cmap        = lines(nModes+1);

roi_fullName    = [num2str(iRoi),'_', roiLabel];
IF.name         = roi_fullName;


modesStdEstimate = estimateIfModeStd(IF, iRoi);

h = figure('visible', cfg.FIG_VISIBLE, 'units','normalized','outerposition', [0 0.07 0.64 0.78]); % specified size
for iMode = 1:nModes
    
    IFmode = IF.spectralModes{iRoi}(iMode,:);
    plt{iMode} = plot(IF.freqAxis, IFmode, '.', 'Color', cmap(iMode,:), 'MarkerSize', cfg.DOT_SIZE);
    hold on
    tmp = plot(IF.freqAxis, IFmode,'Color', cmap(iMode,:), 'LineWidth', cfg.LINE_WIDTH);
    tmp = bar(IF.freqAxis, IFmode, 'FaceAlpha', 0.1, 'LineWidth', 0.00001, 'FaceColor', cmap(iMode,:),'LineStyle', 'none');
    plt{iMode}.Color(4) = 0.3; % transparency
    hold on   
    
    % plot shaded error bars
    if(cfg.STD_OPACITY > 0)
        ub = IFmode + modesStdEstimate(iMode,:);
        lb = IFmode - modesStdEstimate(iMode,:);
        loop = [IF.freqAxis, fliplr(IF.freqAxis)];
        inBetween = [ub, fliplr(lb)];
        fill(loop, inBetween, ...
            [plt{iMode}.Color(1) plt{iMode}.Color(2) plt{iMode}.Color(3)], ...
            'LineStyle', 'none', 'FaceAlpha', cfg.STD_OPACITY);
    end
    
    % get peak frequency
    if(cfg.LABEL_PEAKS)
        [f, pf] = getPeakFrequency(IFmode, IF.freqAxis);
        scatter(f, pf, 60, 'sb','LineWidth',2)
        df = -4; dpf = 0.05;
        t = sprintf('\\color[rgb]{0.5,0.5,0.5} [%.1f, %.1f]', f, pf);
        text(f+df, pf+dpf, t, 'FontSize', 17);
    end
end

hold off

title(sprintf('Individual Fingerprint: SUB=%d\nROI: %s', iSub, IF.name), 'Interpreter','none','FontSize', 20,'FontWeight','bold');

xlabel('Frequencies (Hz)');
ylabel('Normalised power');

set(h.CurrentAxes.XAxis, 'fontsize', 20)
set(h.CurrentAxes.YAxis, 'fontsize', 20)
xlim([min(IF.freqAxis) max(IF.freqAxis)])

grid minor
hline(0,'k');

if nModes > 0
    modesTime = num2str(round(IF.clusterDuration{iRoi}',1));
    lgd = num2str((1:nModes)');
    lgdObj = legend([plt{:}], strcat(lgd, ' - T=', modesTime, ' %'), 'Location', 'best');
    lgdObj.FontSize = 18;
    lgdObj.Color = 'none';
end

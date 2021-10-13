function plotSF(cfg, iRoi)
% cfg - contains field SRC_DIR (the directory with STAGE_5/output directories)
% and DOT_SIZE (radius of the dots to be plotted on scatterplots)
% iRoi - roi index

inputFolder = [cfg.SRC_DIR, '/STAGE_5/output/'];
load([inputFolder, 'CFG.mat'])
load([inputFolder, 'singleRoiSpectralFingerprint_iROI', num2str(iRoi), ...
      '.mat'])

SF = singleRoiSpectralFingerprint;
roiLabel = CFG.Global.sourceAtlasAndSourceModel.sourceAtlas(1).tissuelabel{iRoi};
nModes = size(SF.lvl2_gmm_centroids, 1);
cmap = lines(nModes+1);

roi_fullName = [num2str(iRoi),'_', roiLabel];
SF.name = roi_fullName;

SF.spectralModes  = SF.lvl2_gmm_centroids;
SF.duration       = SF.lvl2_gmm_centroidDuration;
nonPopularModesIdx  = find(SF.lvl2_gmm_nSubjectsPerCentroid < CFG.STAGE_5.majoritySubjectsNum);
popularModesIdx     = find(SF.lvl2_gmm_nSubjectsPerCentroid >= CFG.STAGE_5.majoritySubjectsNum);

h = figure('visible', cfg.FIG_VISIBLE, 'units','normalized','outerposition', [0 0.07 0.64 0.78]); % specified size

modesStdEstimate = estimateSfModeStd(SF);
for iMode = 1:nModes
    
    SFmode = SF.spectralModes(iMode,:); 
    
    if(ismember(iMode, nonPopularModesIdx))
        plt{iMode} = plot(SF.freqAxis, SFmode, 'o', 'Color', cmap(iMode,:), 'MarkerSize', cfg.DOT_SIZE/4);
        hold on
        tmp = plot(SF.freqAxis, SFmode, ':', 'Color', cmap(iMode,:), 'LineWidth', cfg.LINE_WIDTH);
        tmp = bar(SF.freqAxis, SFmode, 'FaceAlpha', 0.1, 'LineWidth', 0.00001, 'FaceColor', cmap(iMode,:), 'LineStyle', 'none');
        hold off    
    else
        plt{iMode} = plot(SF.freqAxis, SFmode, '.', 'Color', cmap(iMode,:), 'MarkerSize', cfg.DOT_SIZE);
        hold on
        tmp = plot(SF.freqAxis, SFmode,'Color', cmap(iMode,:), 'LineWidth', cfg.LINE_WIDTH);
        tmp = bar(SF.freqAxis, SFmode, 'FaceAlpha', 0.1, 'LineWidth', 0.00001, 'FaceColor', cmap(iMode,:),'LineStyle', 'none');
        hold off
    end
    plt{iMode}.Color(4) = 0.3; % transparency
    
    hold on
   
    if(cfg.STD_OPACITY > 0)
    % add shaded error bars
    ub = SFmode + modesStdEstimate(iMode,:);
    lb = SFmode - modesStdEstimate(iMode,:);
    loop = [SF.freqAxis, fliplr(SF.freqAxis)];
    inBetween = [ub, fliplr(lb)];
    fill(loop, inBetween, ...
        [plt{iMode}.Color(1) plt{iMode}.Color(2) plt{iMode}.Color(3)], ...
        'LineStyle', 'none', 'FaceAlpha', cfg.STD_OPACITY);
    end

    % get peak frequency
    if(cfg.LABEL_PEAKS)
        [f, pf] = getPeakFrequency(SFmode, SF.freqAxis);
        scatter(f,pf,60,'sb','LineWidth',2)
        df = -4; dpf = 0.05;
        t = sprintf('\\color[rgb]{0.5,0.5,0.5} [%.1f, %.1f]', f, pf);
        text(f+df, pf+dpf, t, 'FontSize', 17);
    end
    
end

hold off

title(sprintf('Spectral Fingerprint: %s', SF.name), 'Interpreter','none','FontSize', 20,'FontWeight','bold');

xlabel('Frequencies (Hz)');
ylabel('Normalised power');

set(h.CurrentAxes.XAxis, 'fontsize', 20)
set(h.CurrentAxes.YAxis, 'fontsize', 20)
xlim([min(SF.freqAxis) max(SF.freqAxis)])

grid minor
hline(0,'k');

if nModes > 0
    modesTime = num2str(round(SF.duration',1));
    lgd = num2str((1:nModes)');
    lgdObj = legend([plt{:}], strcat(lgd, ' - T=', modesTime, ' %'), 'Location', 'best');
    lgdObj.FontSize = 18;
    lgdObj.Color = 'none';
end

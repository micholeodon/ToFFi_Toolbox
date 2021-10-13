% Subroutine of networksPlot.m

disp 'Plotting ...'
%% Tree
cutoff = median([bl.Linkage(end-treeLvl+1,3) bl.Linkage(end-treeLvl+2,3)]);
switch cfg.labelMode
    case 'number'
        [dendLines,~,~] = dendrogram(bl.Linkage, numel(bl.TreeFull.leafNodesIndices), 'ColorThreshold', cutoff, 'Labels', leafRoiNumberString);
        xtickangle(45)
    case 'name'
        [dendLines,~,~] = dendrogram(bl.Linkage, numel(bl.TreeFull.leafNodesIndices), 'ColorThreshold', cutoff, 'Labels', leafLabels);
        xtickangle(90)
    otherwise
        error('ERROR! Wrong value of cfg.labelMode !')
end
set(gca,'TickLabelInterpreter','none')
f               = gcf;
f.Units         = 'normalized';
f.OuterPosition = [0 0 1 1];
title(['ROI similarity tree ; lvl = ', num2str(treeLvl)],  'Interpreter', 'None');
set(gca,'ytick',[])
set(gca,'yticklabel',[])
h(1) = gcf;

% match labels with colors
nLeafs      = numel(leafLabels);
roiColor    = zeros(nLeafs, 3);
roiGroup    = zeros(nLeafs,1);
linesColor  = cell2mat(get(dendLines,'Color'));
colorList   = unique(linesColor, 'rows');

for iLeaf = 1:nLeafs
    [iRow, ~]   = find(bl.Linkage==iLeaf);
    iRoi        = leafRoiNumbers(iLeaf);
    color               = linesColor(iRow,:);
    roiColor(iLeaf,:)   = color;
    roiGroup(iLeaf,:)   = find(ismember(colorList, color, 'rows'));
end

switch cfg.figSave
    case 'y'
        disp 'Saving ...'
        createOutputDir

        % tree
        fname1      = ['tree_', num2str(treeLvl)];        
        savefig(h(1), [outDir, fname1, '.fig'])
        saveas(h(1), [outDir, fname1, '.png'])
   case 'n'
    otherwise
        error('ERROR! Wrong value of cfg.figSave !')
end

%% Both hemispheres
showOn3dBrain(leafRoiNumbers, roiGroup, sourceAtlas, colorList, 'both');
colorbar off
pause(2)
h(2) = gcf; % 3d - both
switch cfg.figSave
    case 'y'    
        % 3d views
        fname2      = ['both_', num2str(treeLvl)];        
        savefig(h(2), [outDir, fname2, '.fig'])
        saveas(h(2), [outDir, fname2, '.png'])
    case 'n'
    otherwise
        error('ERROR! Wrong value of cfg.figSave !')
end

%% Right hemisphere only
showOn3dBrain(leafRoiNumbers, roiGroup, sourceAtlas, colorList,'right');
colorbar off
pause(2)
view([-90 0])
camlight
h(3) = gcf; % 3d - right in
switch cfg.figSave
    case 'y'
        fname3      = ['right_in_', num2str(treeLvl)];        
        savefig(h(3), [outDir, fname3, '.fig'])
        saveas(h(3), [outDir, fname3, '.png'])       
    case 'n'
    otherwise
        error('ERROR! Wrong value of cfg.figSave !')
end

view([90 0])
camlight
h(4) = gcf; % 3d - right out
switch cfg.figSave
    case 'y'       
        fname4      = ['right_out_', num2str(treeLvl)];        
        savefig(h(4), [outDir, fname4, '.fig'])
        saveas(h(4), [outDir, fname4, '.png'])       
    case 'n'
    otherwise
        error('ERROR! Wrong value of cfg.figSave !')
end

%% Left hemisphere only
showOn3dBrain(leafRoiNumbers, roiGroup, sourceAtlas, colorList, 'left');
colorbar off
pause(2)
view([90 0])
camlight
h(5) = gcf; % 3d - left in
switch cfg.figSave
    case 'y'      
        fname5      = ['left_in_', num2str(treeLvl)];        
        savefig(h(5), [outDir, fname5, '.fig'])
        saveas(h(5), [outDir, fname5, '.png'])
    case 'n'
    otherwise
        error('ERROR! Wrong value of cfg.figSave !')
end

view([-90 0])
camlight
h(6) = gcf; % 3d - left out
switch cfg.figSave
    case 'y'
        fname6      = ['left_out_', num2str(treeLvl)];        
        savefig(h(6), [outDir, fname6, '.fig'])
        saveas(h(6), [outDir, fname6, '.png'])

        disp 'Saving done!'
    case 'n'
    otherwise
        error('ERROR! Wrong value of cfg.figSave !')
end

%%
disp 'Plotting done!'

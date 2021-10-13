clear
close all
clc
addpath ../

%% USER SETTINGS
% For this script no additional settings are needed.

%% 
CommonInit

%%
for iSub = 1:nSub
    iSubCode = subFolders_LIST{iSub};
    disp([ num2str(iSub), ' / ' , num2str(nSub) ])
    iSubCode
    
    % load covariance in order to have grad
    sp = [outputPath, iSubCode, '/']; % location for save
    files_prefix    = [sp, iSubCode];
    load([files_prefix, '_MEG_3-Restin_rmegpreproc_preproc_covmat.mat'])
    grad                    = datavg.grad;
    grad                    = ft_convert_units(grad,'cm');
    datavg.grad             = grad;
    
    % load vol
    files_prefix    = [p_df, iSubCode, '/MEG/anatomy/', iSubCode];
    fileVol         = [ '_MEG_anatomy_headmodel.mat'];             % Subject's brain volume
    load([files_prefix, fileVol])
    vol             = ft_convert_units(headmodel,'cm');
    
    % load leadfield
    files_prefix    = [outputPath, iSubCode, '/', iSubCode];
    fileLFG         = ['_MEG_anatomy_leadfield_VEC_3d8mm.mat'];
    load([files_prefix, fileLFG])
    
    %----- Set initial source localization settings
    srcCfg = [];
    srcCfg.vol              = vol;
    srcCfg.method           = 'lcmv';
    % project on axis of most variance using SVD
    srcCfg.fixedori         = 'yes'; % in HCP is 'no' 
    srcCfg.feedback         = 'text';
    srcCfg.lambda           = '7%'; % changed to from 75% to 7% according to Keitel's parameters
    srcCfg.projectnoise     = 'no';
    srcCfg.keepfilter       = 'yes';
    srcCfg.keepleadfield    = 'yes';
    srcCfg.keepmom          = 'no';
    
    %--- Select only channels of current data set in already computed leadfields -----------
    [indA, indB]            = match_str(datavg.label, lfg.label);
    Nsrc                    = numel(lfg.leadfield(lfg.inside));
    lfgCase                 = lfg;
    
    lfgInsideSize = size(lfg.leadfield(lfg.inside)); 
    if(lfgInsideSize(1) > lfgInsideSize(2))
        lfgCase.leadfield(lfgCase.inside) = cellfun(@(x,y) x(y,:), lfg.leadfield(lfg.inside), repmat({indB}, 1, Nsrc)', 'UniformOutput', false);
    else
        lfgCase.leadfield(lfgCase.inside) = cellfun(@(x,y) x(y,:), lfg.leadfield(lfg.inside), repmat({indB}, 1, Nsrc), 'UniformOutput', false);
    end
    
    srcCfg.grid             = lfgCase;
    srcCfg.grid.label       = lfgCase.label(indB);
    
    %----- Compute Inverse Solution from Covariance matrix ------------
    %  this provides the spatial filters that will project the data for the
    %  time points and time periods of interest
    disp('beamforming starting...');
    source = ft_sourceanalysis(srcCfg, datavg);
    disp('beamforming finished !')
    
    % extract filter weights to the form same as in Keitel & Gross 2016
    inside_indices = find(source.inside);
    spatialFilterCell = {source.avg.filter{inside_indices}};
    Nchans = size(spatialFilterCell{1},2);
    spatialFilter = nan(Nsrc, Nchans);
    % pull out filter vectors from cell to an array rows
    for iVox = 1:Nsrc
        spatialFilter(iVox,:) = spatialFilterCell{iVox};
    end
    isAnyVoxelLeftUnprocessed = any(any(isnan(spatialFilter))); % sanity check
    
    % save
    if(~exist(sp, 'dir'))
        mkdir(sp)
    end
    outputFilename = [sp, iSubCode,  '_MEG_3-Restin_source_LCMV_3d8mm.mat'];
    save(outputFilename, 'source')
    outputFilename = [sp, iSubCode,  '_MEG_3-Restin_spatialFilter_LCMV_3d8mm.mat'];
    save(outputFilename, 'spatialFilter')

end
disp DONE!
clear
close all
clc
addpath ../

%% USER SETTINGS
dataType = 'MEG'; % 'EEG' or 'MEG' (default)

%% 
CommonInit

%% 

for iSub = 1:nSub
    iSubCode = subFolders_LIST{iSub};
    disp([ num2str(iSub), ' / ' , num2str(nSub) ])
    iSubCode
    
    % load covariance in order to have grad field
    sp = [outputPath, iSubCode, '/']; % location for save
    files_prefix    = [sp, iSubCode];
    load([files_prefix, '_MEG_3-Restin_rmegpreproc_preproc_covmat.mat'])
    grad            = datavg.grad;
    grad            = ft_convert_units(grad,'cm');
    Cy = datavg.cov;
      
    % load source model (sourcemodel3d) and head model (vol)
    files_prefix    = [p_df, iSubCode, '/MEG/anatomy/', iSubCode];
    fileGrid3D      = [ '_MEG_anatomy_sourcemodel_3d8mm.mat'];
    fileVol         = [ '_MEG_anatomy_headmodel.mat']; % Subject's brain volume
    load([files_prefix, fileGrid3D])
    grid = ft_convert_units(sourcemodel3d, 'cm');
    
    load([files_prefix, fileVol])
    vol             = ft_convert_units(headmodel,'cm');
     
    %----- Create Leadfields ---------------------------------------
    lfg = [];
    
    cfg = [];
    cfg.grid            = grid; % Grid for individual's brain in MEG sensor space
    cfg.vol             = vol;
    cfg.grad            = grad;
    switch dataType
        case 'MEG'
            cfg.reducerank = 2; % (default = 3 for EEG, 2 for MEG)
            selChans         = ft_channelselection({'MEG'}, grad.label);
        case 'EEG'
            cfg.reducerank = 3; % (default = 3 for EEG, 2 for MEG)
            selChans         = ft_channelselection({'EEG'}, grad.label);
        otherwise
            cfg.reducerank = 'no';
    end
    cfg.normalize       = 'yes' ; % Normalise Leadfield: 'yes' for beamformer
    cfg.normalizeparam  = 1; % depth normalization parameter
    cfg.channel         = selChans;
    lfg                 = ft_prepare_leadfield(cfg);
    lfg.label           = selChans;
    
    % save standard (vector) leadfield 
    if(~exist(sp, 'dir'))!
        mkdir(sp)
    end
    outputFilename = [sp, iSubCode,  '_MEG_anatomy_leadfield_VEC_3d8mm.mat'];
    save(outputFilename, 'lfg')
    
    % compute and save the leadfield for the optimal dipole orientation
    % (SVD approach)
    ratio = 0.07;
    lambda = ratio * trace(Cy)/size(Cy,1);
    invCy = pinv(Cy + lambda * eye(size(Cy)));
    
    [indA, indB]            = match_str(datavg.label, lfg.label);
    Nsrc                    = numel(lfg.leadfield(lfg.inside));
    Nchan                   = numel(indB);
    clear datavg
    
    nDip = size(lfg.pos,1);
    lfgSVD.leadfield = cell(1, nDip);
    lfgSVD.AllChanLabels = lfg.label;
    lfgSVD.SelChan = lfg.label(indB);
    lfgSVD.SelChanIdx = indB;
    lfgSVD.inside = lfg.inside;
    for iDip = 1:nDip
        
        if ~isempty(lfg.leadfield{iDip})
            lf = lfg.leadfield{iDip}(indB,:);            
            [u, s, v] = svd(real(pinv(lf' * invCy *lf)));
            eta = u(:,1);
            lf  = lf * eta;
            lfgSVD.leadfield{iDip} = lf;
        else
            lfgSVD.leadfield{iDip} = [];
        end
    end
    
    outputFilename = [sp, iSubCode,  '_MEG_anatomy_leadfield_SVD_3d8mm.mat'];
    save(outputFilename, 'lfgSVD')
    
end
disp DONE!

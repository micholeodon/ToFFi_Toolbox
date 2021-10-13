clear
close all
clc
addpath ../

%% USER SETTINGS
doDetrending = 1; % 0 - no or 1 - yes (default)

%% 
CommonInit

%% 
for iSub = 1:nSub
    
    iSubCode = subFolders_LIST{iSub}; 
    disp([ num2str(iSub), ' / ' , num2str(nSub) ]) 
    iSubCode
    
    % load HCP rmegpreproc dataset
    load([p_df, iSubCode, '/MEG/Restin/rmegpreproc/', iSubCode, '_MEG_3-Restin_rmegpreproc.mat'])
    
    % reslice
    data_old = data;
    cfg=[];
    cfg.durationMillisec = 1000;
    data = dataResliceContinuousDataCells(cfg, data);
    data.hdr = data_old.hdr;
    data.grad = data_old.grad;
    
    % detrend data - help combat edge artifacts
    disp('Data detrending (trial-wise) ...')
    cfg = [] ;
    cfg.detrend = 'yes';
    data = ft_preprocessing(cfg, data);
    
    sp = [outputPath, iSubCode, '/']; % location for save
    if(~exist(sp, 'dir'))
        mkdir(sp)
    end
    
    outputFilename = [sp, iSubCode, '_MEG_3-Restin_rmegpreproc_preprocessed.mat'];
    save(outputFilename, 'data')
end
disp DONE!
clear
close all
clc
addpath ../

%% USER SETTINGS
DO_DATA_COND = 0; % 1 or 0 (default); if 1 then data is multiplied by 1e14

%% 
CommonInit

%% 
for iSub = 1:nSub

    iSubCode = subFolders_LIST{iSub};
    disp([ num2str(iSub), ' / ' , num2str(nSub) ])
    iSubCode
    
    % load HCP rmegpreproc dataset
    sp = [outputPath, iSubCode, '/']; % location for save
    load([sp, iSubCode, '_MEG_3-Restin_rmegpreproc_preprocessed.mat'])
    
    if DO_DATA_COND
        % conditioning the data
        for tt = 1:length(data.trial)
            data.trial{tt}(:,:) = data.trial{tt}*1e14;
        end
    end
    
    calcCovMatrix
    
    if(~exist(sp, 'dir'))
        mkdir(sp)
    end
    
    outputFilename = [sp, iSubCode,  '_MEG_3-Restin_rmegpreproc_preproc_covmat.mat'];
    save(outputFilename, 'datavg')
end
disp DONE!
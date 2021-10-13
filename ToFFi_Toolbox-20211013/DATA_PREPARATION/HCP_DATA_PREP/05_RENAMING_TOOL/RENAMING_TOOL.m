clear; close all; clc;
%%
% Script that take subject related files from source directory with
% consistent naming convention, renames them according to other naming
% convention and saves in selected destination directory.
%
% ASSUMPTION ! Only one file matching name is present in subject directory.

%% ==== USER SETTINGS: =========================================================
inputCfg.path          = '../output/'; % source directory where data to be renamed are
outputCfg.path         = '../output/000000_RENAMED/';

inputCfg.SubCodes      = {'100307','102816','105923','106521', ... 
                          '108323','109123','111514','112920', ...
                          '113922','116524'}; % input subject codes
outputCfg.SubCodes     = {'Sub_1', 'Sub_2', 'Sub_3', 'Sub_4', ...
                          'Sub_5', 'Sub_6', 'Sub_7', 'Sub_8', ...
                          'Sub_9', 'Sub_10'}; % new subject codes

% sizes of two lists below should match
inputCfg.dataNames     = {  '_MEG_3-Restin_rmegpreproc_preprocessed', ...
                            '_MEG_3-Restin_rmegpreproc_preproc_covmat', ...
                            '_MEG_anatomy_leadfield_SVD_3d8mm', ...
                            '_MEG_anatomy_leadfield_VEC_3d8mm', ...
                            '_MEG_3-Restin_source_LCMV_3d8mm', ...
                            '_MEG_3-Restin_spatialFilter_LCMV_3d8mm'};
outputCfg.dataNames    = {  'data_clean_HCP_att2', ...
                            'data_clean_covmat_HCP_att2', ...
                            'lfg_SVD_HCP_att2', ...
                            'lfg_VEC_HCP_att2', ...
                            'source_LCMV_HCP_att2', ...
                            'flt_LCMV_HCP_att2'};

outputCfg.namesFormat  = 'name_subNum';   % use combination with 'name' (obligatory),
% 'subCode', 'subNum'.
% e.g.: 
% If outputCfg.dataNames = {'sig', 'filt'}, 
%    outputCfg.SubCodes = {'AS05', 'JK13'},
%    outputCfg.SubNums = [4 3],
% Then following files will be outputted for given values of
% outputCfg.namesFormat:
%     
%     'name_subNum'  -> sig_4.mat , filt_4.mat, sig_3.mat, filt_3.mat
%     'subCode_name' -> AS05_sig.mat, AS05_filt.mat, JK13_sig.mat, JK13_filt.mat
%     'subNum_name' -> 4_sig.mat, 4_filt.mat, 3_sig.mat, 3_filt.mat

%%
addpath '../../../globalFunctionsScripts/'
addpath './external/'
addpath './external/kakearney-subdir-pkg-7f6f8de/subdir/'

inputCfg.path = fixPath(inputCfg.path);
outputCfg.path = fixPath(outputCfg.path);

inputCfg.SubNums       = 1:numel(inputCfg.SubCodes); 
outputCfg.SubNums      = 1:numel(outputCfg.SubCodes); 

iCount = 0;
for iSub = 1:numel(inputCfg.SubNums)
    for iData = 1:numel(inputCfg.dataNames)
        iCount = iCount + 1;
        
        % search
        listInputFiles{iCount} = searchRecursively(inputCfg.dataNames{iData}, [inputCfg.path, inputCfg.SubCodes{iSub}, '/']);
        listInputFiles{iCount} = fixPath(listInputFiles{iCount});
        
        % prepare changes list
        outputName = strrep(outputCfg.namesFormat, 'name', outputCfg.dataNames{iData});
        outputName = strrep(outputName, 'subCode', outputCfg.SubCodes{iSub});
        outputName = strrep(outputName, 'subNum', num2str(outputCfg.SubNums(iSub)));
        listOutputFiles{iCount} = [outputCfg.path, outputCfg.SubCodes{iSub}, '/', outputName, '.mat'];
    end
end

%% ask questions (interactive)
% list OK? YES-> proceed, NO-> manually edit list of changes and manually proceed

for iFile = 1:iCount
    LIST_FILE_CHANGES{iFile} = [listInputFiles{iFile}, ' -> ', listOutputFiles{iFile}];
end

disp('Here is the list of planned copies: ')
disp(LIST_FILE_CHANGES')

doAsk = 1;
while(doAsk)
    prompt = 'Do you agree with it? y/n : ';
    answer = input(prompt,'s');
    
    switch answer
        case 'n'
            doAsk = 0;
            disp('OK you can manually edit LIST_FILE_CHANGES variable and then run rest of the script from section ''PROCESS''.');
            return
        case 'y'
            doAsk = 0;
            disp('OK. So proceeding with changes ... Please wait ...')
        otherwise
            warning('Wrong option (is small case?)')
            doAsk = 1;
    end
end



%% PROCESS
% verbosely show old_path/old_name -> newpath/new_name and save that info
% to text file

for iFile = 1:iCount
    
    disp(['Processing: ', num2str(iFile), ' / ', num2str(iCount), ' ...']);
    
    [filepath, name, ext] = fileparts(listOutputFiles{iFile});
    if(~exist(filepath, 'dir'))
        mkdir(filepath)
    end
    
    copyfile(listInputFiles{iFile}, listOutputFiles{iFile})
    
end
disp('DONE !')


%% FINISH

stamp = datestr(datetime('now'),'yyyy_mm_dd_HH-MM-ss');

% save subject codes change information
for iSub = 1:numel(inputCfg.SubCodes)
    LIST_SUB_CODES_CHANGES{iSub} = [inputCfg.SubCodes{iSub}, ',', outputCfg.SubCodes{iSub}];
end
fid = fopen([outputCfg.path, '/', stamp, '_subjCodes_change.txt'],'w');
CT = LIST_SUB_CODES_CHANGES.';
fprintf(fid,'%s\n', CT{:});
fclose(fid);


% save list of changes information
fid = fopen([outputCfg.path, '/', stamp, '_files_change.txt'],'w');
CT = LIST_FILE_CHANGES.';
fprintf(fid,'%s\n', CT{:});
fclose(fid);




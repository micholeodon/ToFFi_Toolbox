%%
% This script is used to generate .mat files containing Desikan-Killiany
% cortical+subcortical individual atlases for selected subjects from the MEG HCP
% dataset to be further processed by Spectral Fingerprint algorithm.
%
%% WARNING on using on Windows !
% This script works correctly on Unix systems. On Windows, it produces the
% following error:
%
% "WARNING: fsgettmppath: could not find a temporary folder, using current folder
% cd [...]
% ERROR: 'zcat' is not recognized as an internal or external command,
% operable program or batch file."
%
% One has two options to solve this problem: 
% 1. Use precomputed brain atlases provided already in the 
% DATA_PREPARATION/PARCELLATIONS_PREP/DK_individual_atlases/output_precomputed/
% directory.
% 2. Provide missing zcat program, which load_nifti.m (Fieldtrip function)
% depends on. Here is what to do:
% - Download UnxUtils archive (https://sourceforge.net/projects/unxutils/).
% - Unpack archive anywhere.
% - Find zcat.exe and copy into
% DATA_PREPARATION/PARCELLATIONS_PREP/DK_individual_atlases/ directory
% - Read DESCRIPTION and INSTRUCTION sections below.
% - Run Desikan_Killiany_preparation.m in MATLAB. Now the script should work
% just fine. 
%
%% DESCRIPTION
% It is assumed that HCP data is downloaded somewhere, let us say
% '/home/johndoe/HCP_data/', 
% (3T_Structural_preproc data pack at https://db.humanconnectome.org)
% and they have following structure and obligatory files
% (example for two subjects '100307' and '102816'). Note that there might be
% additional directories like MEG, anatomy, provenance, figures, etc. Their
% presence will not harm anything. It is crucial to have at least the files
% shown below:
%
% /home/johndoe/HCP_data/
%                    ├── 100307
%                    │   ├── MNINonLinear
%                    │   │   ├── aparc+aseg.nii.gz
%                    │   │   │   ...
%                    ├── 102816
%                    │   ├── MNINonLinear
%                    │   │   ├── aparc+aseg.nii.gz
%                    │   │   │   ...
%                    ...
%
% It is also assumed that user has working MATLAB software and Fieltrip
% toolbox installed.
%
%% INSTRUCTION
% 1. Open MATLAB and set its working directory to directory containing this file.
% 2. Open this file to edit it.
% 3. Set inputDataPath variable to path to the root of the tree above.
% 4. Set fieldTripPath variable to path to the Fieltrip toolbox.
% 5. Set nSub variable to desired number of subject to be processed (by default equals 89).
% 7. Run this script. Few minutes later there should be first files of the
% new data inside the ./output/ directory.
%
% NOTE! Output files will be named DK_indAtlas_X.mat where X corresponds to the
% subject number. Subject number are assigned according to the order in
% subjCodes variable (DK_Init.m file). Each output .mat file contains field
% with the subject HCP code.
%% CODE

clear; close all; clc

%% SETTINGS
inputDataPath = 'C:\johndoe\HCP_data\';
fieldTripPath = 'C:\johndoe\fieldtrip-20210816\';

nSub = 89; % number of files from subFolders_LIST variable (below) to process

%%
DK_Init

%% prepare atlases 1/2
% iSubMax variable: choose one of subjects from list below to share its
% labels, otherwise use anybody.
for iSub = 1:nSub
    
    iSubCode = subFolders_LIST{iSub};
    refSubjects = {'109123', '112920', '113922', '116524', '133019', '146129', '154532', ...
        '162935', '164636', '166438', '172029', '174841', '175540', '179245', ...
        '181232', '191437', '195041', '205119', '212318', '212823', '214524', ...
        '221319', '248339', '257845', '283543', '287248', '293748', '559053', ...
        '581450', '601127', '660951', '662551', '665254', '679770', '680957', ...
        '707749', '715950', '735148', '783462', '825048', '891667', '898176', '912447'};
    % subject 109123 has most common labels for all subjects (relevant for
    % part 2/2)
    if ismember('109123', subFolders_LIST(1:nSub))
        iSubMax = find(ismember(subFolders_LIST(1:nSub), '109123'));
        break;
    elseif ismember(iSubCode, refSubjects)
        iSubMax = iSub;
        break;
    else
        iSubMax = iSub;
    end
end

for iSub = 1:nSub
    
    iSubCode = subFolders_LIST{iSub};
    
    disp([ num2str(iSub), ' / ' , num2str(nSub) ])
    iSubCode
    
    % load
    atlasFile = [inputDataPath, iSubCode, '/MNINonLinear/aparc+aseg.nii.gz'];
    if(~exist(atlasFile))
        warning(['Subject no ', num2str(iSub), ' : ', iSubCode, ' skipped ! (file not exist!)'])
        continue
    end
    atlas = ft_read_atlas(atlasFile);
    % approx. 112 labels
    
    % change fields names
    atlas.tissue = atlas.aparc;
    atlas.tissuelabel = atlas.aparclabel;
    atlas = rmfield(atlas, 'aparc');
    atlas = rmfield(atlas, 'aparclabel');
    
    % interpolation to the common template grid
    load ../../../commonData/templategrid_HCP_8mm.mat
    cfg = [];
    cfg.interpmethod        = 'nearest';
    cfg.parameter           = 'tissue';
    sourceAtlas  = ft_sourceinterpolate(cfg, atlas, sourcemodel);
    
    % add rest of the fields
    sourceAtlas.iSub = iSub;
    sourceAtlas.subCode = iSubCode;
    
    % add atlas to the structure for processing later
    atlases(iSub) = sourceAtlas;
end
%% prepare atlases 1/2
% This part will force every subject's atlas to have the same tissuelabel
% and modify tissue values accordingly (change values not location)

labsRef = atlases(iSubMax).tissuelabel;

% relabel subjects atlases
for iSub = 1:nSub
    disp(['Relabeling subject ... ', num2str(iSub)])
    
    oldTissueMatrix = atlases(iSub).tissue;
    oldTissuelabels = atlases(iSub).tissuelabel;
    
    newTissueMatrix = oldTissueMatrix;
    newTissuelabels = labsRef;
    nOldTissuelabels = numel(oldTissuelabels);
    for iTissue = 1:nOldTissuelabels
        oldTissueLabel = oldTissuelabels(iTissue);
        newTissue = find(ismember(newTissuelabels, oldTissueLabel));
        newTissueMatrix(newTissueMatrix == iTissue) = -newTissue;  % minus to prevent accidental mixing with old tissues
    end
    atlases(iSub).tissue = abs(newTissueMatrix); % cancelling the minus sign above
    atlases(iSub).tissuelabel = newTissuelabels;
end

%% save
for iSub = 1:nSub
    
    sourceAtlas = atlases(iSub);
    
    % save
    sp = outputPath; % location for save
    if(~exist(sp, 'dir'))
        mkdir(sp)
    end
    
    outputFilename = [sp, 'DK_indAtlas_', num2str(iSub), '.mat'];
    save(outputFilename, 'sourceAtlas')
end
disp DONE!

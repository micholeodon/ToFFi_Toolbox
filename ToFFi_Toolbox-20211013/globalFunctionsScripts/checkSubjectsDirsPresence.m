function isMissingSubjectDirs = checkSubjectsDirsPresence(directory, indices)
%% Inputs
% *directory* - directory where to look for subjects' directories.
%
% *indices* - double 1D-array of indices of subjects to look for. Usually in
%           CFG.Global.goodSubjects.
%% Outputs
% *isMissingSubjectDirs* - flag that shows if subject directories are present
%                          (0) or not (1)
%%
directory = fixPath(directory);

if(~ischar(directory)) error('ERROR: Directory argument is invalid type !'); end
if(strcmp(directory, '')) error('Directory name is empty !'); end
if(isempty(directory)) error('Directory name is empty !'); end

if(isempty(indices)) error('empty indices vector !'); end
if(~isnumeric(indices)) error('Non-numeric indices are forbidden!'); end
if(iscolumn(indices)) indices = indices'; end
if(~all(mod(indices,1)==0)) error('Floating point indices are forbidden!'); end


SUB_DIR_PREFIX = 'Sub_';

% list of subjects and list of data. Warn if too many dirs
list_subjects = getFilesMatchingName(SUB_DIR_PREFIX, directory);

if(numel(list_subjects) > numel(indices))
    warning('There are more subject directories in ', directory, [' directory than ' ...
            'subjects listed in ''indices'' argument. Was it intended?']);
end

% warn user that not every subject has its own folder
isMissingSubjectDirs = 0;
for iSub = indices
    if(~ismember([SUB_DIR_PREFIX, num2str(iSub)], list_subjects))
	isMissingSubjectDirs = 1;
	warning(['Subject ', num2str(iSub), ' directory missing !']);
    end
end

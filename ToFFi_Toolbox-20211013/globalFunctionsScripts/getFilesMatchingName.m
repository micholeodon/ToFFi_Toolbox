function listFilesMatching = getFilesMatchingName(name, src_dir)
%%
% Lists files or directories with matching name inside selected
% directory. This search is non-recursive.
%% Inputs
% *name* - char; case-sensitive name of the file or directory looked for.
%
% *src_dir* - char; path to the selected directory to look inside.
%
%% Outputs
% *listFilesMatching* - cell; list of directories / files matching *name* argument.
%
%%

%% check
if(ischar(name))
    % ok
elseif(iscell(name))
    name = name{:};
elseif(isempty(name))
    warning('name argument is empty !')
else
    error('Wrong name type !')
end

if(ischar(src_dir))
    % ok
elseif(iscell(src_dir))
    name = name{:};
else
    error('Wrong src_dir type !')
end

src_dir = fixPath(src_dir);
if(~exist(src_dir, 'dir')) error([src_dir, ' : Directory not exist !']); end

%% search

% dir source
allFiles = dir(src_dir);
allFiles([1 2]) = [];  % remove . and .. from list

if(isempty(allFiles)) listFilesMatching = []; warning([src_dir, ' : warning - directory is empty!']); end

% arrange in a cell array
cnt = 0;
listFilesMatching = [];
for ff = 1:length(allFiles)
    if(isempty(strfind(allFiles(ff).name, name)))
	     continue;
    end
    cnt = cnt +1;
    listFilesMatching{cnt} = allFiles(ff).name;
end

if(length(listFilesMatching) == 0)
    warning([src_dir, ' : List of matching files is empty !']);
else
    disp('List of matching files created.')
end

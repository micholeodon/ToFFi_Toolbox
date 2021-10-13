function [isDirEmpty, nFiles] = checkIsDirEmpty(directory)
%%
% Function that checks if *directory* input argument leads to an empty directory.
% Returns:
%
% - flag *isDirEmpty* which equals 1 if directory is empty and 0 if
%   not.
%
% - *nFiles* which is the number of files and subdirectories found inside
%   *directory*
%%
if(~ischar(directory)) error('ERROR: Input directory variable is of wrong type !'); end
directory = fixPath(directory);
if(~exist(directory, 'dir')) error('ERROR: Directory not exist !'); end


folderContent = dir(directory);
nFiles = numel(folderContent) - 2; % -2 because of '.' and '..'
if(nFiles > 0)
    isDirEmpty = 0;
else
    isDirEmpty = 1;
end

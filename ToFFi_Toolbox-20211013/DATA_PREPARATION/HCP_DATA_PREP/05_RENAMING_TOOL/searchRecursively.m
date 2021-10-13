function fileLocation = searchRecursively(name, src_dir)
% List files or directories with matching name in a form of a cell array.
% Search in subdirs also.
%
% It makes use of subdir.m by Kelly Kearney.
%
% ASSUMPTION ! Only one file matching name is present in subject directory.
%

if(isempty(strfind(name, '.mat')))
    tmp = subdir([src_dir, '/', '*', name, '*.mat']);
else
    tmp = subdir([src_dir, '/', '*', name]);
end

if(numel(tmp) > 1) 
    warning('List of matched files:')
    tmp(:).name
    error('More than one matching file exist! It violates the function assumption !');
end
fileLocation = tmp.name;

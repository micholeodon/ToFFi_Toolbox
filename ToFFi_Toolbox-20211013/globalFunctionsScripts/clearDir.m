function clearDir(directory)
%%
% Remove all files from selected directory.
%%

try
    rmdir([directory, '*'], 's') % delete subdirectories
catch
end

try
    delete([directory, '*']) % delete files
catch
end

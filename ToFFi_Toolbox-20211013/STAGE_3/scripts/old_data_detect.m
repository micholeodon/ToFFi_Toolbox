[dirEmptyFlag, nFiles] = checkIsDirEmpty(directory);

if(dirEmptyFlag)
    isOldDataPresent=0;
else
    if(nFiles > 1)
	isOldDataPresent = 1;
    else % nFiles == 1
        if(exist([directory, 'CFG.mat'], 'file'))
            warning('Only config file found (are you sure it is up to date?)');
            isOldDataPresent = 0;
        else
            isOldDataPresent = 1;
        end
    end
end

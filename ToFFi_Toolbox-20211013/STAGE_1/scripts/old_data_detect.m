% for each subject directory at that stage check if it is empty
if(~exist('goodSubjectIndices', 'var')) error('ERROR: goodSubjectIndices variable not exist !'); end

evalc('[~, listGoodSubjects, ~] = makeSubjectAndDataLists(''Sub_'', ''../output/'', ''DUMMY'', goodSubjectIndices)');

numSubjects         = length(listGoodSubjects);
emptyDirBoolArray   = zeros(1, numSubjects);
for iSub    = 1:length(listGoodSubjects)
    iSubDir = [directory, listGoodSubjects{iSub}, '/'];

    isDirEmpty              = checkIsDirEmpty(iSubDir);
    emptyDirBoolArray(iSub) = isDirEmpty;
end

if(any(~emptyDirBoolArray))
    isOldDataPresent = 1;
else
    isOldDataPresent = 0;
end

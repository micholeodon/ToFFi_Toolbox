function listGoodSubjects = removeBadSubjectsFromList(listSubjects, goodSubjectIndices)
%%
% Keeps only those subject in *listSubjects* argument that have indices
% listed in *goodSubjectIndices* argument.
%% Inputs
% *listSubjects* - cell; contains names of the subjects i.e. {'Sub_1',
%                  'Sub_2} Usually one of the outputs from
%                  _makeSubjectAndDataLists.m_
%
% *goodSubjectsIndices* - double; array of good subject indices that are used
%                         to filter out *listSubjects* cell from bad subjects.
%% Outputs
% listGoodSubjects - cell; contains names of the subjects after removal of
%                    bad subjects.
%%
%%
% argument check

if(~iscellstr(listSubjects)) error('List of subject is not a cell with strings !'); end
if(iscell(goodSubjectIndices)) error('List of indices of good subject should be a numeric vector with positive numbers !'); end
if(~isnumeric(goodSubjectIndices)) error('List of indices of good subject should be a numeric vector with positive numbers !'); end
isRow = isrow(goodSubjectIndices);
isColumn = iscolumn(goodSubjectIndices);
if((~isRow) && (~isColumn))
    error('List of indices of good subject should be a numeric vector with positive numbers !');
else
    if(isColumn)
	goodSubjectIndices = goodSubjectIndices';
    end
end

%%
% main

SUB_DIR_PREFIX = 'Sub_';

nIndices            = length(goodSubjectIndices);
listGoodSubjects    = cell(1, nIndices);
for iIndex = 1:nIndices
    iSub = goodSubjectIndices(iIndex);
    subjName    = [SUB_DIR_PREFIX, num2str(iSub)];
    indexInList = find(ismember(listSubjects, subjName));

    if(isempty(indexInList))
    else
	listGoodSubjects{iIndex} = listSubjects{indexInList};
    end
end

listGoodSubjects = removeEmptyCells(listGoodSubjects);


if(isempty(listGoodSubjects))
    error('Fatal error! List of good subject is empty !');
end

%%
% functions
    function x = removeEmptyCells(x)
	x = x(~cellfun('isempty', x));
    end



end

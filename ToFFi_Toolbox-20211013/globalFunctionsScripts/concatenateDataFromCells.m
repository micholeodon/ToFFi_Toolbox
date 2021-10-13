function dataOut = concatenateDataFromCells(data)

% Also possible for matrices with data of form [ channels x time ].
% Matrices are concatenated horizontally.

if(~iscell(data)) error('Data is not a cell array !'); end

numCells        = length(data);
trialLengths    = nan(1, numCells);

for iCell = 1:numCells
   if(ischar(data{iCell})) error('Data cannot contain chars or strings !'); end

   trialLengths(iCell) = size(data{iCell}, 2);
end
if(any(trialLengths == 0)) error('Some cells were empty !'); end

dataOut{1} = [data{:}];

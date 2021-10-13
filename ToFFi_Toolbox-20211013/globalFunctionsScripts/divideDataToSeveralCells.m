function [dataMultiCell, isAnyColumnLost] = divideDataToSeveralCells(cfg, dataSingleCell)


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(~isstruct(cfg)) error('cfg argument is not a struct !'); end

divideByNumCells = isfield(cfg, 'numCells');
divideByNumColumnsPerCell = isfield(cfg, 'numColumnsPerCell');

if(divideByNumCells && divideByNumColumnsPerCell)
    error('cfg contains both numCells and numColumnsPerCell. Choose only one of those !');
end

if(~iscell(dataSingleCell)) error('Data is not a cell array !'); end
if(numel(dataSingleCell) > 1) error('More than one cell in the input data !'); end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

totalLength         = size(dataSingleCell{:}, 2);
isAnyColumnLost    = 1;

if divideByNumCells
    numCells = cfg.numCells;

    if(~isInteger(numCells)) error('Wrong type of cfg.numCells !'); end
    if(numCells < 1) error('Cannot divide to less than 1 cell !'); end
    if(numCells > totalLength) error('Cannot divide to more cells than number of columns in input cell !'); end

    numColumnsPerCell  = floor(totalLength/numCells);
%     isAnyColumnLost    = ~(mod(totalLength, numColumnsPerCell) == 0);

elseif divideByNumColumnsPerCell
    if(~isInteger(cfg.numColumnsPerCell)) error('Wrong type of cfg.numColumnsPerCell !'); end
    if(cfg.numColumnsPerCell > totalLength) error('Cannot divide to more number of columns than number of them already available !'); end

    numColumnsPerCell  = cfg.numColumnsPerCell;
    numCells            = floor(totalLength/numColumnsPerCell);
%     isAnyColumnLost    = ~(mod(totalLength, numColumnsPerCell) == 0);

else
    error('Fatal error: Unrecognized state of the function ! Probably wrong cfg argument.');
end


%% division
dataMultiCell   = cell(1, numCells);
trialLengths    = numColumnsPerCell*ones(1, numCells);
for iCell = 1:numCells
    currentStartSampleIndex     = sum(trialLengths( 1 : (iCell-1)   )) + 1;
    currentEndSampleIndex       = sum(trialLengths( 1 : iCell       ));

    dataMultiCell{iCell} = dataSingleCell{1}(:, currentStartSampleIndex : currentEndSampleIndex);
end


isAnyColumnLost = ~isequal([dataMultiCell{:}], [dataSingleCell{:}]);

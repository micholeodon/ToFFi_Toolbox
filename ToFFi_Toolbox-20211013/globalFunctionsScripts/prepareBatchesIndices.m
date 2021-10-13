function [listBatchIndices, nBatches] = prepareBatchesIndices(nElementsInBatch, nTotalElements)
%%
% Funtion divides set of nTotalElements to nBatches subsets and outputs list
% of indices in each batch along with the number of resulting
% batches. Function accounts for division with residual, so last batch will
% contain nElementsInBatch or less elements.
%% Inputs
% *nElementsInBatch* - double; positive integer; up to how many elements
%                      indices can be in single batch.
%
% *nTotalElements* - double; positive integer; means what is the total number
%                    of elements to be divided into batches.
%% Outputs
% *listBatchIndices* - cell of 1D-arrays; Each array store indices for single
%                      batch. Total number of indices stored in this cell
%                      equals *nTotalElements*.
%
% *nBatches* - double; positive integer; number of batches produced in order
%              to divide *nTotalElements* into separate sets of
%              *nElementsInBatch* number of items.
%% Example:
% [l, n] = prepareBatchesIndices(2, 5)
%
% l{1}
%
%   =  1  2
%
% l{2}
%
%   =  3  4
%
% l{3}
%
%   =  5
%
% n = 3
%%

if(~isnumeric(nElementsInBatch)) error("nElementsInBatch argument is not numeric !"); end
if(~isequal(size(nElementsInBatch), [1 1])) error("nElementsInBatch argument is a 1x1 !"); end
if(~isnumeric(nTotalElements)) error("nTotalElements argument is not numeric !"); end
if(~isequal(size(nTotalElements), [1 1])) error("nTotalElements argument is a 1x1 !"); end

nResidualElements   = mod(nTotalElements, nElementsInBatch);

if(nResidualElements > 0)
    nBatches            = floor(nTotalElements / nElementsInBatch) + 1; % +1 for residual number of elements
else
    nBatches            = floor(nTotalElements / nElementsInBatch);
end

listBatchIndices = cell(1, nBatches);


if(nResidualElements > 0)
    for iBatch = 1:(nBatches-1)
	listBatchIndices{iBatch} = ((iBatch-1)*nElementsInBatch + 1):(iBatch*nElementsInBatch);
    end
    listBatchIndices{nBatches} = (nTotalElements-nResidualElements+1):nTotalElements;
else
    for iBatch = 1:nBatches
	listBatchIndices{iBatch} = ((iBatch-1)*nElementsInBatch + 1):(iBatch*nElementsInBatch);
    end

end

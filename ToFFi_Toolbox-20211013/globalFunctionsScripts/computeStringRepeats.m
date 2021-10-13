function [uniqueStringArray, repeatsCount] = computeStringRepeats(cellStringArray)
%%
% Outputs *uniqueStringArray* which is a cell array containing unique strings
% found in cell array *cellStringArray* and outputs *repeatsCount* which is
% an 1D-array with integers showing how many times each unique string occured
% in the input cell array.
%%
uniqueStringArray = unique(cellStringArray,'stable');
repeatsCount = cellfun(@sumRepeats, uniqueStringArray, 'UniformOutput',0);

    function y = sumRepeats(singleString)
	y = sum(ismember(cellStringArray, singleString));
    end

end

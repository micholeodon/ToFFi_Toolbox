function [out_cID, oldOrder, newOrder] = reNumerateClusters(cID)
%%
% Maps numbers in the input vector onto subsequent natural numbers, e.g.:
%
% [2 4 1 3 1 1]  -> [1 2 3 4 3 3]'
%% Inputs
% *cID* - double; 1D-array of integers.
%
%% Outputs
% *out_cID* - double; 1D-array of integers. Remapped input array.
%
% *oldOrder* - double; 1D-array of integers. Unique integers from *cID* in
%              order of their appearance.
%
% *newOrder* - double; 1D-array of integers equals sequence
%              1:numel(unique(cID)). Unique integers from *out_cID* in order of
%              their appearance.
%% Example
% cID = [2 4 1 3 1 1];
%
% [out_cID, old, new] = reNumerateClusters(cID)
%
% c2 =
%
%     1     2     3     4     3     3
%
% o =
%
%     2     4     1     3
%
% n =
%
%     1     2     3     4
%%

if(iscell(cID)) error('Input argument should be a numeric vector, not a cell !'); end
if(~isvector(cID)) error('Input argument should be a vector, not a matrix !'); end

isColumn = iscolumn(cID);

N       = length(cID);
list    = -ones(1,N);

if isColumn
    out_cID = zeros(N,1);
else
    out_cID = zeros(1,N);
end

jNext   = 1;

for i = 1:N
    iOnList = find(list==cID(i));
    if(isempty(iOnList))
	list(jNext) = cID(i);
	jNext       = jNext+1;
	out_cID(i)  = jNext-1;
    else
	out_cID(i)  = iOnList;
    end

end

oldOrder = list( list ~= (-1) );
newOrder = 1:length(oldOrder);

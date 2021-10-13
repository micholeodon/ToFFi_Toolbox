function emptyStruct = initArrayOfStruct(nElements, benchmarkStructure)
%%
% Function that inits empty struct with declared number (nElements) of
% fields and same fields as in benchmarkStructure.
%%
fieldList   = fieldnames(benchmarkStructure);
nFields     = length(fieldList);

for iField = 1:nFields
    emptyStruct(nElements).(fieldList{iField}) = [];
end

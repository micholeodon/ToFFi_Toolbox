clear; close all; clc;


subjList = {'Sub_1', 'Sub_10', 'Sub_2', 'Sub_3'};
good = [1 10 3 5]; % 5 is not on the list; list is not sorted

goodList = removeBadSubjectsFromList(subjList, good)

expectedList = {'Sub_1', 'Sub_10', 'Sub_3'};

if(isequal(goodList, expectedList))
    disp('Test passed.')
else
    disp('Test FAILED.')
end
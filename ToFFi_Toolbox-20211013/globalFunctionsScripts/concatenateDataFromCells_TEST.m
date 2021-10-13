clear; close all; clc;

%function dataOut = concatenateDataFromCells(data)

passed = 0;
total = 0;

% data is not a cell array (ERR)
clear data
data = magic(3);
try
    concatenateDataFromCells(data);
catch
    passed = passed + 1;
end
total = total + 1;


% cells with matrices (ERR)
clear data
data{1} = 1:3;
data{2} = 1:5;
data{3} = magic(4);
data{4} = 1;
try
    concatenateDataFromCells(data);
catch
    passed = passed + 1;
end
total = total + 1;


% some cells with text (ERR)
clear data
data{1} = 1:3;
data{2} = 1:5;
data{3} = 'foo';
data{4} = 1;
try
    concatenateDataFromCells(data);
catch
    passed = passed + 1;
end
total = total + 1;


% empty cells (ERR)
clear data
data{1} = 1:3;
data{2} = 1:5;
data{3} = [];
data{4} = '';
try
    concatenateDataFromCells(data);
catch
    passed = passed + 1;
end
total = total + 1;


% proper data 1
clear data
data{1} = 1:3;
data{2} = 1:5;
data{3} = 1;
data{4} = 1;
try
    dataOut = concatenateDataFromCells(data);
    passed = passed + 1;
catch
end
total = total + 1;

% proper data 2
clear data
data{1} = 1;
data{2} = 1;
data{3} = 1;
data{4} = 1:5;
try
    dataOut = concatenateDataFromCells(data);
    passed = passed + 1;
catch
end
total = total + 1;


% output size test
if(iscell(dataOut))
    passed = passed+1;
    total = total + 1;

    if(length(size(dataOut{:})) == 2) passed = passed+1; end
end
total = total + 1;

%% SUMMARY

disp(['Test passed ', num2str(passed), ' / ', num2str(total) ])

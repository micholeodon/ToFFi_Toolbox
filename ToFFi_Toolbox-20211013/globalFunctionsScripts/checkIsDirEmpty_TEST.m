clear; close all; clc;

% isDirEmpty = checkIsDirEmpty(directory)
passed = 0;
total = 0;


try
    directory = 'checkIsDirEmpty_TEST/empty/';
    isEmpty = checkIsDirEmpty(directory);
    passed = passed + 1;
catch
end
total = total + 1;

try
    directory = 'checkIsDirEmpty_TEST/non_empty/';
    isEmpty = checkIsDirEmpty(directory);
    passed = passed + 1;
catch
end
total = total + 1;

%%

try
    directory = 'checkIsDirEmpty_TEST/non_existent/';
    isEmpty = checkIsDirEmpty(directory);
catch
    passed = passed + 1;
end
total = total + 1;

try
    directory = {'wrong type'};
    isEmpty = checkIsDirEmpty(directory);
catch
    passed = passed + 1;
end
total = total + 1;


%%
disp(['Tests finished. Passed ', num2str(passed), ' / ', num2str(total), '.']);

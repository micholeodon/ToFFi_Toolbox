clear; close all; clc;

% Test for function: getFilesMatchingName(name, src_dir).m

%%
passed = 0;
total = 0;
% non-existent dir
try
    getFilesMatchingName('Sub_', 'fooooo')
catch
    passed = passed + 1;
end
total = total+1;

% empty dir
try
    getFilesMatchingName('Sub_', '')
catch
    passed = passed + 1;
end
total = total+1;

try
    getFilesMatchingName('Sub_', [])
catch
    passed = passed + 1;
end
total = total+1;

% integer dir
try
    getFilesMatchingName('Sub_', 23)
catch
    passed = passed + 1;
end
total = total+1;

% float dir
try
    getFilesMatchingName('Sub_', 1.7)
catch
    passed = passed + 1;
end
total = total+1;

% pwd
getFilesMatchingName('Sub_', './')
passed = passed + 1;
total = total+1;

getFilesMatchingName('Sub_', '.')
passed = passed + 1;
total = total+1;
%%

% non-existent name
getFilesMatchingName('foooo', './')

% empty name
getFilesMatchingName('', './')
getFilesMatchingName([], './')

% integer name
try
getFilesMatchingName(5, './')
catch
    passed = passed + 1;
end
total = total + 1;

% float name
try
getFilesMatchingName(6.2, './')
catch
    passed = passed + 1;
end
total = total + 1;

% name as a keyword
try
getFilesMatchingName(svd(randn(3)), './')
catch
    passed = passed + 1;
end
total = total + 1;

% partially matching name, but not what intended
getFilesMatchingName('Sub', './')
passed = passed + 1;
total = total + 1;

%%

disp(['Tests finished. Passed ', num2str(passed), ' / ', num2str(total), '.']);

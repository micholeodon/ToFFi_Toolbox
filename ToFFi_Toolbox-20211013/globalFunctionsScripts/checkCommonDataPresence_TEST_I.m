clear; close all; clc;
% checkCommonDataPresence(globalConfig)

% TEST_I = interactive test - user needed :)

%%
answer = askQuestion('Did you check that in checkCommonDataPresence_TEST/ there are files listed inside checkCommonDataPresence.m function?', {'y', 'n'});
if(strcmp(answer, 'n'))
    warning('So fix that and then run this test. Otherwise it will not make sense.');
    return;
end

%%
passed = 0;
total = 0;

directory = 'checkCommonDataPresence_TEST/';
globalConfig.commonDataDir = directory;
try
    checkCommonDataPresence(globalConfig);
    passed = passed + 1;
catch
end
total = total + 1;

answer = askQuestion('In the next question choose NO ! Ready?', {'y'});
directory = 'checkCommonDataPresence_TEST/empty/';
globalConfig.commonDataDir = directory;
try
    checkCommonDataPresence(globalConfig);
catch
    passed = passed + 1;
end
total = total + 1;

answer = askQuestion('In the next question choose YES ! Ready?', {'y'});
directory = 'checkCommonDataPresence_TEST/empty/';
globalConfig.commonDataDir = directory;
try
    checkCommonDataPresence(globalConfig);
    passed = passed + 1;
catch
end
total = total + 1;
%%

disp(['Tests finished. Passed ', num2str(passed), ' / ', num2str(total), '.']);

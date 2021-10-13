clear; close all; clc;
passed  = 0;
total   = 0;
%%

% prep atlases
d = './loadIndAtlases_TEST/';
cd(d)
prepExamples
cd ../
ls(d)

% wrong path, good subjects
wp = './wrong/path/';
gs = [1 2];
try
    A = loadIndAtlases(wp, gs)
catch
    passed = passed + 1;
end
total = total + 1;

% good path, wrong subjects
ws = [56, 1, 2];
try
    A = loadIndAtlases(d, ws)
catch
    passed = passed + 1;
end
total = total + 1;

% good path, good subjects
try
    A = loadIndAtlases(d, gs)
    passed = passed + 1;
catch
end
total = total + 1;

%% Summary
disp(['Tests finished. Passed ', num2str(passed), ' / ', num2str(total), '.']);
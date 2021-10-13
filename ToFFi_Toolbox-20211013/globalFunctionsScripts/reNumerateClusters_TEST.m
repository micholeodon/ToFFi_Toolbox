clear; close all; clc;

% Test for:
% - constant ordering of clusters despite random start of centroids
% - [idx,C,sumd] = kmeans(___)  - idx, C and sumd variables in has correct order of entries

%%

% MATLAB's standard kmeans output
% DO NOT CHANGE VALUES !
idx     = [2 3 1 3 1 1]';
C       = [0 0; 1 0; 0 1];
sumd    = [4.1; 6.8; 3.7];

% we renumerate clusters
[new_idx, oldOrder] = reNumerateClusters(idx);

% so we need to reorder rows in C and sumd
new_C       = C(oldOrder,:);
new_sumd    = sumd(oldOrder,:);

exp_new_idx     = [1 2 3 2 3 3]';
exp_new_C       = [1 0; 0 1; 0 0];
exp_new_sumd    = [6.8; 3.7; 4.1];


c1 = isequal(new_idx, exp_new_idx);
c2 = isequal(new_C, exp_new_C);
c3 = isequal(new_sumd, exp_new_sumd);

if(c1 && c2 && c3)
    disp('Test passed.')
else
    disp('Test FAILED.')
end

% script plotting the result of the STAGE 8

clear; close all; clc;
addpath ./functions
addpath ../common_functions

%% SETTINGS (user edits this section)
cfg = [];
% % path to repository root '../../' or path to selected backup directory
cfg.srcDir      = '../../';
% integer > 1 - number of networks to display , [] - maximum possible
cfg.treeLevel   = 4; 
 % 'number' to display ROIs' indices or 'name' to display full ROIs' names
cfg.labelMode   = 'name';  
% 'y' (save figures as .fig and .png) or 'n' (do not save figures)
cfg.figSave     = 'y';      

%% PROCESSING
S_loadData
S_calcTree
S_plotAndSave

%%
disp 'ALL DONE!'

% This script takes advantage of the fact that individual grid points coincide in
% normalized space, so you can take templated grid from any subject and it
% will be good.
clear; close all; clc;

%% EDIT THOSE VARIABLES
subjectAnatomyPath = 'C:\johndoe\HCP_data\111514\MEG\anatomy\'
subCode = '111514'

%% DO NOT EDIT
subjectAnatomyPath = fixPath(subjectAnatomyPath);

disp('Loading ...')
load([subjectAnatomyPath, subCode, '_MEG_anatomy_sourcemodel_3d8mm.mat'])
disp('Extracting and purging unnecessary fields (important !)...')

sourcemodel = sourcemodel3d.cfg.grid.template;
sourcemodel = rmfield(sourcemodel,'cfg');
sourcemodel = rmfield(sourcemodel,'unit');
sourcemodel = rmfield(sourcemodel,'trackcallinfo');
sourcemodel = rmfield(sourcemodel,'checksize');
sourcemodel = rmfield(sourcemodel,'trackconfig');
sourcemodel = rmfield(sourcemodel,'checkconfig');
sourcemodel = rmfield(sourcemodel,'showcallinfo');
sourcemodel = rmfield(sourcemodel,'debug');
sourcemodel = rmfield(sourcemodel,'trackdatainfo');
sourcemodel = rmfield(sourcemodel,'trackparaminfo');

disp('Saving ...')
save('../../commonData/templategrid_HCP_8mm.mat', 'sourcemodel') 

disp('DONE !')
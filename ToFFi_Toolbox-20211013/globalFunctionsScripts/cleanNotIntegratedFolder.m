function cleanNotIntegratedFolder(notIntegratedFolder)
%%
% Removes all files from STAGE_X/output/not_integrated directory (if exists).
%
% Background:
% Some stages output contain temporary output files placed in the
% _not_integrated_ directory. Those files were produced in given stage by single
% jobs / workers / iterations. They need to be merged together into single
% data structure or file. This is done by STAGE_X/scripts/INTEGRATE.m routines.
%%
notIntegratedFolder = fixPath(notIntegratedFolder);
if(~exist(notIntegratedFolder, 'dir')) error('Directory not exist !'); end

disp('Cleaning directory with not-integrated files ...')
clearDir(notIntegratedFolder);
disp('Directory with not-integrated files cleaned.')

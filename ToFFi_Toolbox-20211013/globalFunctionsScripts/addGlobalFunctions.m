function addGlobalFunctions(globalConfig)
%%
% Adds paths to routines common for all stages.
%% Inputs
% *globalConfig* - struct; Holds configuration variables common for all
% stages. Used fields:
%
% _rootDir_ - char; absolute path to your script root directory (directory
% where you have STAGE_ directories inside).
%
%%

if(~isfield(globalConfig, 'rootDir'))
    error('No rootDir field in global CFG !');
end

addpath([globalConfig.rootDir, './globalFunctionsScripts']);

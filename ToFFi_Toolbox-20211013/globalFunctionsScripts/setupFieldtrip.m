function setupFieldtrip(globalConfig)
%%
% Adds path to Fieldtrip routines. See: https://www.fieldtriptoolbox.org/
%% Inputs
% *globalConfig* - struct; Holds configuration variables common for all
% stages. Used fields:
%
% _fieldtripPath_ - char; absolute path to Fieldtrip plugin directory (one
% that contains ft_defaults.m)
%
%%

if(~isfield(globalConfig, 'fieldtripPath')) error('No fieldtripPath field in global CFG !'); end

globalConfig.fieldtripPath = fixPath(globalConfig.fieldtripPath);
addpath(globalConfig.fieldtripPath);
ft_defaults

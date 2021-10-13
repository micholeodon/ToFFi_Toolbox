function setupFieldtrip(globalConfig)

if(~isfield(globalConfig, 'fieldtripPath')) error('No fieldtripPath field in global CFG !'); end
globalConfig.fieldtripPath = fixPath(globalConfig.fieldtripPath);

addpath(globalConfig.fieldtripPath);
ft_defaults

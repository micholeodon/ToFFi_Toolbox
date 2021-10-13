disp('Checking names ...')

% Should look like this:
% globalConfig.STAGE_1.dataVarNamePrefix = 'data';
% globalConfig.STAGE_1.filterVarName = 'spatialFilter';

if(~exist('data', 'var')) error('Incorrect loaded data variable name'); end
if(~exist('spatialFilter', 'var')) error('Incorrect loaded filter variable name'); end

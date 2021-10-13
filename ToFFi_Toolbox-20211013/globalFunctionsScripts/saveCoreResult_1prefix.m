function saveCoreResult_1prefix(cfg, variableToSave)
%%
% Save selected variable to the file with meaningful name.
%% Inputs
% *cfg* - struct with fields:
%
% _variablePrefix_ - char; first word in the filename
%
% _thingPrefix_ - char; name of the element type to be saved (e.g. 'ROI', 'Sub')
%                 to serve as meaningful second that index (after first
%                 prefix stored in _variablePrefix_) in the saved file name.
%
% _thingIndex_ -  double; integer that means thich thing in the set of things
%                 saved data refers to, e.g. which ROI, which subject, which
%                 iteration, etc.
%
% _tmpFolder_ - char; destination directory where file should be saved
%
% *variableToSave* - variable to saved (any type and size).
%%

if(~isfield(cfg, 'variablePrefix')) error('Missing field variablePrefix in cfg argument !'); end
if(~isfield(cfg, 'thingPrefix')) error('Missing field thingPrefix in cfg argument !'); end
if(~isfield(cfg, 'thingIndex')) error('Missing field thingIndex in cfg argument !'); end
if(~isfield(cfg, 'tmpFolder')) error('Missing field tmpFolder in cfg argument !'); end


prefix              = [cfg.thingPrefix, num2str(cfg.thingIndex)];
fname               = [cfg.variablePrefix, '_', prefix];
mkdir(cfg.tmpFolder);
variableName        = inputname(2);
eval([variableName ' = variableToSave;'])
s_path = [cfg.tmpFolder, '/', fname, '.mat'];
s_path = fixPath(s_path);
save(s_path, variableName);

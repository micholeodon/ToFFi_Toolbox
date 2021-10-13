function sourceAtlas = prepareAtlasFromMatFile(atlasPath)
%%
% To find some information about atlas preparation read comments in
% prepareAtlas.m
%%
atlasPath = fixPath(atlasPath);
if(~exist(atlasPath, 'file')) error('Wrong atlasPath argument ! File not exist !'); end

load(atlasPath);

% example
%
% sourceAtlas =
%
%   struct with fields:
%
%             dim: [21 23 19]
%       transform: [4×4 double]
%            unit: 'cm'
%          tissue: [21×23×19 double]
%     tissuelabel: {1×116 cell}
%             cfg: [1×1 struct]

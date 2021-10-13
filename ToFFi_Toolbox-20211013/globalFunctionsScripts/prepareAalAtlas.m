function sourceAtlas = prepareAalAtlas(atlasPath, sourceModel)
%%
% To find some information about atlas preparation read comments in
% prepareAtlas.m
%%

atlasPath = fixPath(atlasPath);
if(~exist(atlasPath, 'file')) error('Wrong atlasPath argument ! File not exist !'); end

atlas = ft_read_atlas(atlasPath);

cfg = [];
cfg.interpmethod        = 'nearest';
cfg.parameter           = 'tissue';
sourceAtlas     = ft_sourceinterpolate(cfg, atlas, sourceModel);
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

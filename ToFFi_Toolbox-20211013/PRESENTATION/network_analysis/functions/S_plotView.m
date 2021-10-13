% plot selected view (subroutine of showOn3dBrain)

disp('Creating surface view ...')
cfg                     = [];
cfg.feedback            = 'no';
cfg.method              = 'surface'; % this is important to prevent black spots !
cfg.projmethod          = 'project'; % this is important to prevent black spots !
cfg.projvec             = [0 5];
cfg.surfdownsample      = 10;        % smoothing
cfg.projcomb            = 'max';     % this helps spread color more evenly
cfg.renderer            = 'zbuffer';
cfg.camlight            = 'yes';

switch viewType
    case 'both'
        % VIEW 1 - both
        cfg.surffile = [fieldtripPath 'template/anatomy/surface_white_both.mat'];
        cfg.cmap                = [[1,1,1]; colorMap];
    case 'left'
        % VIEW 2 - left
        cfg.surffile = [fieldtripPath 'template/anatomy/surface_white_left.mat'];
        cfg.cmap                = [[1,1,1]; colorMap];
    case 'right'
        % VIEW 3 - right
        cfg.surffile = [fieldtripPath 'template/anatomy/surface_white_right.mat'];
        cfg.cmap                = [[1,1,1]; colorMap];
    case 'slice'
        cfg.method              = 'slice';
        cfg.nslices             = 20;
        cfg.slicerange          = [1 81];
        cfg.locationcoordinates = 'voxel';
        cfg.location            = [41, 52, 49]; % some custom typical location (in voxels, not cm) !
        cfg.cmap                = [[0,0,0]; colorMap];
    otherwise
        error('Error ! Argument viewType should equal ''both'' or ''left'' or ''right'' or ''slice'' !')
end

cfg.locationcoordinates = 'voxel';
cfg.funcolormap         = cfg.cmap;
cfg.funparameter        = 'selROInatural';
cfg.atlas               = atlas;
cfg.facecolor           = 'brain'; % to prevent 'cortex_light' bug (Fieldtrip)
ft_sourceplot(cfg, chosenROI)
function okFlag = checkIndAtlasFields(atlas)
%%
% This function checks if an atlas structure has all the obligatory fields,
% and if they are of proper type and dimensionality.
%% Inputs
% *atlas* - struct; represents individual subject atlas; Should contain fields:
%
% _iSub_ - double; integer index of subject 
%
% _dim_ - double 1-D array of positive integers; the size of the 3D volume in 
%         voxels
%
% _transform_ - double 2-D array containing affine transformation matrix for 
%               mapping the voxel coordinates to head coordinate system
%
% _unit_ - string; the units in which the coordinate system is expressed
%
% _tissue_ - double 3-D array with integer values from 1 to N (the value 0
%            means unknown). Values are related to the ROI labels stored in
%            _tissuelabel_ fields. Size of each dimension is stored in the 
%            _dim_ field. It stores ROI label for each brain voxel.
%
% _tissuelabel_ - cell of strings containing name of each ROI. 
%% Outputs
% *okFlag* - double; 0 (atlas is not correct) or 1 (atlas is correct)
%%

% check obligatory fields presence
try
    assert(isfield(atlas, 'iSub'));
    assert(isfield(atlas, 'dim'));
    assert(isfield(atlas, 'transform'));
    assert(isfield(atlas, 'unit'));
    assert(isfield(atlas, 'tissue'));
    assert(isfield(atlas, 'tissuelabel'));
    
    okFlag = 1;
catch
    warning(['Error! Loaded atlas is missing one ' ...
        'of the obligatory fields: iSub, path, dim, ' ...
        'transform, unit, tisuse, tissuelabel']);
    okFlag = 0;
end

% check obligatory fields types and dimensions
try
    assert(isInteger(atlas.iSub));
    assert( numel(atlas.iSub) == 1 );
    assert( numel(atlas.dim) == 3 );
    assert( size(atlas.dim, 1) == 1 );
    assert( size(atlas.dim, 2) == 3 );
    assert( isnumeric(atlas.dim) );
    assert( isnumeric(atlas.transform) );
    assert( numel(atlas.transform) == 16 );
    assert( size(atlas.transform, 1) == 4 );
    assert( size(atlas.transform, 2) == 4 );
    assert( isnumeric(atlas.tissue) );
    assert( size(atlas.tissue, 1) == atlas.dim(1) );
    assert( size(atlas.tissue, 2) == atlas.dim(2) );
    assert( size(atlas.tissue, 3) == atlas.dim(3) );
    
    okFlag = and(okFlag, 1);
catch
    warning(['Error! Loaded atlas has field of wrong type / dimension !'])
    okFlag = 0;
end


function [atlas, roiValidForAllSubjects] = prepareAtlas(globalConfig, sourceModel)
%%
% Prepare selected atlas type to be used for Spectral Fingerprinting.
% It branches into subroutines - each takes care of one type of atlas.
% When subroutine has sourceModel as the input given atlas will be
% interpolated onto that source model. If not the atlas file is based on
% fixed-resolution grid (already interpolated).
%% Inputs
% *globalConfig* - struct; Holds configuration variables common for all
% stages. Used fields:
%
% _atlasPath_ - char; path containing data file with atlas (.mat or nifti -
%               depends on the atlas type)
%
% _sourceModelPath_ - char; path containing data file with a source model (.mat)
%
% _atlasType_ - char; possible choices:
%               'AAL' - anatomical with 116 ROI (Details:
%               https://www.fieldtriptoolbox.org/template/atlas/#the-aal-atlas).
%               (Note: same atlas i.e. same voxel-label relation will be used for 
%               all subjects)
%
%               'Schaefer100' - functional atlas with 100 ROI (Details:
%               https://pubmed.ncbi.nlm.nih.gov/28981612/)
%               (Note: same atlas i.e. same voxel-label relation will be used for 
%               all subjects)
%
%               'matfile' - loads user-defined premade atlas from .mat file
%               (Note: same atlas i.e. same voxel-label relation will be used for 
%               all subjects)
%
%               'individual' - loads user-defined premade atlases from .mat
%               files (one file per subject, i.e. different voxel-label relation
%               will be used for each subject)
%
% *sourceModel* - struct; represents grid of voxels where brain source
%                 activity will be reconstructed at. Obligatory fields:
%
% _xgrid_ - double; array of possible x-coordinates of brain voxels expressed
%           in milimeters, centimeters or meters.
%
% _ygrid_ - double; array of possible y-coordinates of brain voxels expressed
%           in milimeters, centimeters or meters.
%
% _zgrid_ - double; array of possible z-coordinates of brain voxels expressed
%           in milimeters, centimeters or meters.
%
% _dim_ - double; 3-vector of number voxels in each dimension. Total number
%         of voxels equals (_dim_(1)*_dim_(2)*_dim_(3)).
%
% _pos_ - double; 2-D array of size (_dim_(1)*_dim_(2)*_dim_(3)) x 3. Each
%         row represent 3D-coordinates of single voxels in the grid.
%
% _inside_ - double; 1-D array that lists indices of voxels that lie inside
%            the brain
%
% _outside_ - double; 1-D array that lists indices of voxels that lie outside
%             the brain
%% Outputs
% *atlas* - struct containing common atlas for all subjects or array of
%           structs if atlas type is 'individual' (one struct per subjects); 
%           contains following obligatory fields:
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
%
% Optional output if atlas type is 'individual':
%
% **roiValidForAllSubjects** - double 1-D array containing list of ROIs common
%                            for all subjects, i.e. for each subject each of 
%                            these ROI has at least one entry in the _tissue_ 
%                            field inside **atlas** structure.
%%

if(~isfield(globalConfig, 'atlasPath'))
    error('No atlasPath field in globalConfig argument !');
end
if(~isfield(globalConfig, 'sourceModelPath'))
    error('No sourceModelPath field in globalConfig argument !');
end
if(~isfield(globalConfig, 'atlasType'))
    error('No atlastType field in globalConfig argument !');
end

roiValidForAllSubjects = globalConfig.goodROI; % default value; changed only
                                               % when atlas type is 'individual'

switch globalConfig.atlasType
  case 'AAL'
	atlas = prepareAalAtlas(globalConfig.atlasPath, sourceModel);
  case 'Schaefer100'
	atlas = prepareSchaefer100Atlas(globalConfig.atlasPath, sourceModel);
  case 'matfile'
	atlas = prepareAtlasFromMatFile(globalConfig.atlasPath);
  case 'individual'
    atlas = loadIndAtlases(globalConfig.atlasPath, globalConfig.goodSubjects);
    [atlas, roiValidForAllSubjects] = checkIndAtlasesConsistency(atlas);
  otherwise
	error('ERROR! cfg.atlasType value not recognized! ')
end

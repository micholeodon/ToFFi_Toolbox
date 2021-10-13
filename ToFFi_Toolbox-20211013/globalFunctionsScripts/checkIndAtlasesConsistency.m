function [atlases, roiValidForAllSubjects]  = checkIndAtlasesConsistency(atlases)
%%
% Function that checks if a structure array containing individual brain
% atlases has consistent fields.
%% Inputs
% *atlases* - array of struct. Each struct represents single subject atlas
%             and has the following fields:
%
% _iSub_ - double; integer index of subject 
%
% _path_ - char; path to the source file from which atlas was prepared
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
% *atlases* - same as input.
%
% *roiValidForAllSubjects* - double 1-D array containing list of ROIs common
%                            for all subjects, i.e. for each subject each of 
%                            these ROI has at least one entry in the _tissue_ 
%                            field inside **atlas** structure.
%%
      
nAtlas = numel(atlases);
iSubTable = zeros(1,nAtlas);
for iAtlas = 1:nAtlas
    A = atlases(iAtlas);
    
    % 1. Check for empty fields
    for f = fieldnames(A)'
       if( isempty(A.(f{1})) )
           error(['Error! Atlas no ', num2str(iAtlas), ' has empty fields!'])
       end
    end

    % 2. Check for duplicate labels
    if(numel(unique(A.tissuelabel)) < numel(A.tissuelabel))
        error(['Error! Atlas no ', num2str(iAtlas), ' has duplicates in ' ...
                            'tissuelabel field!'])
    end
    
    %% prepare 2D matrix of label-numbers nAtlas x nLabels
    if(iAtlas == 1)
        refLabels = A.tissuelabel;
        refLabNums = 1:numel(refLabels);
        labelNumsMatrix = zeros(nAtlas, numel(refLabels));
    end
    
    [labPresent, labOrder] = ismember(refLabels, A.tissuelabel);
    % check if all labels are present
    if(~all(labPresent))
        error(['Error! Atlas no ', num2str(iAtlas), ' has missing labels!'])
    end
        
    labelNumsMatrix(iAtlas,:) = labOrder;
    
    %% prepare 2D matrix of unique sorted tissue
    if(iAtlas == 1)
        tissueCell = cell(1, nAtlas);
    end
    
    tissueCell{iAtlas} = setdiff(sort(unique(A.tissue)), 0);
    
    %% note down iSub field values for checking below
    iSubTable(iAtlas) = A.iSub;
    %%
end

% check for iSub field value duplicates (cannot have two different atlases
% linked to the same subject)
if(numel(unique(iSubTable)) < nAtlas)
    error(['Error! There are at least two atlases with the same iSub field ' ...
           'value!'])
end

% check labels order
if(~issorted(labelNumsMatrix, 2, 'ascend')) % all rows should be 1 2 3 ...
    error('Error! Labels order not match across atlases!')
end 

% find common set of ROI that have at least one voxel
roiSet = tissueCell{1};
for iAtlas = 2:nAtlas
    roiSet = intersect(roiSet, tissueCell{iAtlas});
end
roiValidForAllSubjects = roiSet;
if(~isrow(roiValidForAllSubjects))
    roiValidForAllSubjects = roiValidForAllSubjects';
end
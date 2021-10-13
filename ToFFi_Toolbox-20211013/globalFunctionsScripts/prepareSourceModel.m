function sourceModel = prepareSourceModel(sourceModelPath)
%%
% Loads .mat file containing source model. It should express common space for
% all analysed participants to enable comparison between them.
% Brain atlas will be interpolated to this source model in order to fit the
% common space for all participants. More about source models:
% https://www.fieldtriptoolbox.org/tutorial/sourcemodel/#subject-specific_grids_that_are_equivalent_across_subjects_in_normalized_space
%
% NOTE: need not to convert units because Fieldtrip handles it by
% itself according to : http://www.fieldtriptoolbox.org/faq/units/
% [access 15.04.2020 15:15]
%% Inputs
% *sourceModelPath* - char; path to the .mat file containing source model
%                     structure (expected fields listed below).
%% Outputs
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
%            brain
%
% _outside_ - double; 1-D array that lists indices of voxels that lie outside
%             brain
%% Example:
% sourceModel = prepareSourceModel('/home/johndoe/grids/grid_s1.mat')
%
% sourceModel =
%
%   struct with fields:
%
%       xgrid: [-10 -9 -8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10]
%       ygrid: [-13 -12 -11 -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9]
%       zgrid: [-9 -8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9]
%         dim: [21 23 19]
%         pos: [9177×3 double]
%      inside: [2757×1 double]
%     outside: [6417×1 double]
%%

sourceModelPath = fixPath(sourceModelPath);
if(~exist(sourceModelPath, 'file')) error('Wrong sourceModelPath argument ! File not exist !'); end

load(sourceModelPath); % loads sourcemodel variable

sourceModel = sourcemodel;

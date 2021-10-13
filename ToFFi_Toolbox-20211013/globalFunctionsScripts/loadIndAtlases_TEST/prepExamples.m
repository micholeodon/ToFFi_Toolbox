% clear; close all; clc;
% atlas 1
sourceAtlas.dim = [1 3 2];
sourceAtlas.iSub          = 1;
sourceAtlas.transform = eye(4);
sourceAtlas.unit = 'cm';
sourceAtlas.tissue(:,:,2) = zeros(1,3);
sourceAtlas.tissue(:,:,1) = [0 1 2];
sourceAtlas.tissuelabel = {'ROI_1', 'ROI_2'};
sourceAtlas.comment = 'good';
save('test_indAtlas1.mat', 'sourceAtlas')

% atlas 2
clear sourceAtlas
sourceAtlas.iSub          = 2;
sourceAtlas.dim = [1 3 2];
sourceAtlas.transform = eye(4);
sourceAtlas.unit = 'cm';
sourceAtlas.tissue(:,:,2) = zeros(1,3);
sourceAtlas.tissue(:,:,1) = [1 0 2];
sourceAtlas.tissuelabel = {'ROI_1', 'ROI_2'};
sourceAtlas.comment = 'good';
save('test_indAtlas2.mat', 'sourceAtlas')

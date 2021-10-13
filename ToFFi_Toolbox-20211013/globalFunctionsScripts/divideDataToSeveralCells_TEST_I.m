clear; close all; clc;

% function [dataMultiCell, isAnyColumnLost] = divideDataToSeveralCells(cfg, dataSingleCell)

% TEST_I - interactive test - user needed


%% good cfg
%
% clc
%
% dataSingleCell{1} = [1:10; -(1:10)];
%
% listVal = [1 2 3 4 5 10 15];
% nVal = length(listVal);
%
%
% cfg = [];
% for iVal = 1:nVal
%
%     value = listVal(iVal)
%     cfg.numCells = value;
%     [dataMultiCell, isAnyColumnLost] = divideDataToSeveralCells(cfg, dataSingleCell)
%
% end

%%
clc

dataSingleCell{1} = [1:10; -(1:10)];

listVal = [1 2 3 4 5 10 15];
nVal = length(listVal);

cfg = [];

for iVal = 1:nVal

    value = listVal(iVal)
    cfg.numColumnsPerCell = value;
    [dataMultiCell, isAnyColumnLost] = divideDataToSeveralCells(cfg, dataSingleCell)

end

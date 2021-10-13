clear; close all; clc;

passed  = 0;
total   = 0;

%% correct atlases

atlas.iSub          = 1;
atlas.dim           = [1 3 2];
atlas.transform     = eye(4);
atlas.unit          = 'cm';
atlas.tissue(:,:,1) = [0 1 2];
atlas.tissuelabel   = {'ROI_1', 'ROI_2'};

atlases(1) = atlas;
atlases(2) = atlas;
atlases(2).iSub = 2;
atlases(2).tissue = [1 0 2];

try
    checkIndAtlasesConsistency(atlases);
    passed = passed + 1;
catch
end
total = total + 1;

% try how it works when less ROI are common
atlases(2).tissue = [3 0 2];
try
    checkIndAtlasesConsistency(atlases);
    passed = passed + 1;
catch
end
total = total + 1;


%% bad atlases
% check for empty fields
atlases(2).tissue = [];
try
    checkIndAtlasesConsistency(atlases);
catch
    passed = passed + 1;
end
total = total + 1;

% check for duplicate labels
atlases(2).tissue = [1 0 2];
atlases(1).tissuelabel = {'ROI_1', 'ROI_1'};
try
    checkIndAtlasesConsistency(atlases);
catch
    passed = passed + 1;
end
total = total + 1;

% check for missing labels
atlases(1).tissuelabel = {'ROI_1', 'ROI_2'};
atlases(2).tissuelabel = {'ROI_3', 'ROI_1'};
try
    checkIndAtlasesConsistency(atlases);
catch
    passed = passed + 1;
end
total = total + 1;

% check for iSub duplicates
atlases(2).tissuelabel = {'ROI_1', 'ROI_2'};
atlases(2).iSub = 1;
try
    checkIndAtlasesConsistency(atlases);
catch
    passed = passed + 1;
end
total = total + 1;

% check for wrong labels order
atlases(2).iSub = 2;
atlases(2).tissuelabel = {'ROI_2', 'ROI_1'};
try
    checkIndAtlasesConsistency(atlases);
catch
    passed = passed + 1;
end
total = total + 1;
%%
disp(['Tests finished. Passed ', num2str(passed), ' / ', num2str(total), '.']);

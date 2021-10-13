clear; close all; clc;

passed  = 0;
total   = 0;

%% correct atlas

atlas.iSub          = 1;
atlas.dim           = [1 3 2];
atlas.transform     = eye(4);
atlas.unit          = 'cm';
atlas.tissue(:,:,2) = zeros(1,3);
atlas.tissue(:,:,1) = [0 1 2];
atlas.tissuelabel   = {'ROI_1', 'ROI_2'};

try
    assert(checkIndAtlasFields(atlas) == 1);
    passed = passed + 1;
catch
end
total = total + 1;


%% bad atlases
atlas = [];
atlas.iSub          = 1;
atlas.path          = 'path/to/somewhere';
atlas.dim           = [1 3 2];
atlas.transform     = eye(4);
atlas.unit          = 'cm';
atlas.tissue(:,:,2) = zeros(1,3);
atlas.tissue(:,:,1) = [0 1 2];
atlas.tissuelabel   = {'ROI_1', 'ROI_2'};

% now spoiling it
atlas.iSub = '???';
try
    assert(checkIndAtlasFields(atlas) == 1);
catch
    passed = passed + 1;
end
total = total + 1;

atlas.iSub = ones(5);
try
    assert(checkIndAtlasFields(atlas) == 1);
catch
    passed = passed + 1;
end
total = total + 1;

atlas.iSub = 1;
atlas.dim = 1:10;
try
    assert(checkIndAtlasFields(atlas) == 1);
catch
    passed = passed + 1;
end
total = total + 1;

atlas.dim = ['1','2','3'];
try
    assert(checkIndAtlasFields(atlas) == 1);
catch
    passed = passed + 1;
end
total = total + 1;

atlas.dim = [1 3 2];
atlas.transform = NaN;
try
    assert(checkIndAtlasFields(atlas) == 1);
catch
    passed = passed + 1;
end
total = total + 1;

atlas.transform = 1:16;
try
    assert(checkIndAtlasFields(atlas) == 1);
catch
    passed = passed + 1;
end
total = total + 1;

atlas.transform = eye(4);
atlas.tissue = '1';
try
    assert(checkIndAtlasFields(atlas) == 1);
catch
    passed = passed + 1;
end
total = total + 1;

atlas.tissue = zeros(100, atlas.dim(2), atlas.dim(3));
try
    assert(checkIndAtlasFields(atlas) == 1);
catch
    passed = passed + 1;
end
total = total + 1;

atlas.tissue = zeros(atlas.dim(1), 100, atlas.dim(3));
try
    assert(checkIndAtlasFields(atlas) == 1);
catch
    passed = passed + 1;
end
total = total + 1;

atlas.tissue = zeros(atlas.dim(1), atlas.dim(2), 100);
try
    assert(checkIndAtlasFields(atlas) == 1);
catch
    passed = passed + 1;
end
total = total + 1;


%%
disp(['Tests finished. Passed ', num2str(passed), ' / ', num2str(total), '.']);

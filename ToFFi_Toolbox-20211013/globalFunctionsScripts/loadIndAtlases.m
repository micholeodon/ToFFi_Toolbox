function sourceAtlases = loadIndAtlases(atlasPath, goodSubjects)
%%
% To find some information about atlas preparation read comments in
% prepareAtlas.m
%% Output example
%
% Single structure in the output array of structures:
%
% sourceAtlas =
%
%   struct with fields:
%
%            iSub: 4
%             dim: [21 23 19]
%       transform: [4×4 double]
%            unit: 'cm'
%          tissue: [21×23×19 double]
%     tissuelabel: {1×116 cell}
%%
atlasPath = fixPath(atlasPath);
if(~exist(atlasPath, 'file')) error('Wrong atlasPath argument ! File not exist !'); end

% Check if all subject from list have files in the atlas path (obligatory
% suffix indAtlasX, where X is the number of a subject)

atlasFiles = getFilesMatchingName('_indAtlas', atlasPath);

if(isempty(atlasFiles))
    error(['ERROR! atlasFiles list is empty! (Have you hid them inside', ...
        ' ''Sub_'' directories? If so, store all atlas files in single directory.)'])
end

% load all and check 
disp('Loading individual atlases ...')
iAtlas = 0;
for iSub = goodSubjects
    iAtlas = iAtlas + 1;
    
    % search for particular atlas in list
    x = strfind(atlasFiles,['indAtlas_', num2str(iSub), '.']);
    idx = find(~cellfun(@isempty, x));
    if(isempty(idx))
        error(['Error! Missing atlas file for subject ', num2str(iSub), ' !'])
    end
    
    load([atlasPath, atlasFiles{idx}])
    checkIndAtlasFields(sourceAtlas);

    try 
        sourceAtlases(iAtlas) = sourceAtlas;
    catch ME
        error(['Error! Loaded atlases not match to each other: ', ME.message])
    end

    clear sourceAtlas
end

disp('Loading individual atlases DONE!')

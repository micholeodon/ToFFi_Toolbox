function [list_data, list_subjects, isDataMissing] = makeSubjectAndDataLists(partOfSubjDirName, src_dir, data_names, goodSubjectsIndices)
%%
% Search inside selected directory and outputs a list of data files related
% to selected subjects. Outputs also the list of good subjects that were
% found inside selected directory.
% Depends on: getFilesMatchingName.m;
%% Inputs
% *partOfSubjDirName* - char; string that will be search for when listing
% data and subjects. It will be concatenated with numbers in
% goodSubjectsIndices to search for individual files, i.e. if
% partOfSubjDirName='Sub_' and goodSubjectsIndices=[4, 2, 3] then files with
% 'Sub_4', 'Sub_2', 'Sub_3' will be searched for.
%
% *src_dir* - char; path to the selected directory to look inside.
%
% *data_names* - cell; chars with names of files to look for.
%
% *goodSubjectsIndices* - double; array of good subject indices i.e that are
%                         are permitted to be on the output lists.
%% Outputs
% *list_data* - array of struct; each struct is related to one good
%               subject. Each field contain a file name that was found.
%
% *list_subjects* - cell; contains names of the found good subjects
%
% *isDataMissing* - 0 or 1; 1 indicates that not all of intended  data
%                   and / or subjects were found. Warning! Current version of
%                   this function throws error when isDataMissing == 1
%% Example
% [ld, ls, f] = makeSubjectAndDataLists('Sub_', '/home/user/myDataDir/',
%               {'sig', 'beh'}, [4 3]);
%
% will produce output:
%
% ld =
%
%   1×2 struct array with fields:
%
%     sig
%     beh
%
% >> ld(1)
%
% ans =
%
%   struct with fields:
%
%     sig: {'sig_4'}
%     beh: {'beh_4'}
%
% >> ld(2)
%
% ans =
%
%   struct with fields:
%
%     sig: {'sig_3'}
%     beh: {'beh_3'}
%
% >> ls
%
% ls =
%
%   1×2 cell array
%
%    'Sub_3'    'Sub_4'
%
% >> f
%
% f =
%     0
%
%%
% check
if(~ischar(partOfSubjDirName))
   error('Wrong subject name type or empty !')
else
   if(strcmp(partOfSubjDirName, '')) error('Subject name is empty !'); end
end

if(ischar(src_dir))
    % ok
else
    error('Wrong src_dir type !')
end

if(ischar(data_names)) tmp=data_names; clear data_names; data_names{1} = tmp; end

if(~iscellstr(data_names)) error('Wrong data_names type !') ; end

if(iscellstr(data_names) && isempty(data_names)) error('data_names cell is empty !'); end

% fix path just in case
src_dir = fixPath(src_dir);
if(~exist(src_dir, 'dir')) error('Directory not exist !'); end

if(any(cellfun(@isempty, data_names))) error('Some of the data_names are empty !'); end

if(~exist('goodSubjectsIndices','var') || isempty(goodSubjectsIndices))
    noGoodSubArgument = 1;
end

%%

% make lists
noGoodSubArgument=0;

% list of subjects
list_subjects = getFilesMatchingName(partOfSubjDirName, src_dir);
if(isempty(list_subjects)) error(['No subject directories in ', src_dir, '  directory !']); end

if(noGoodSubArgument)
    goodSubjectsIndices = list_subjects;
end

listGoodSubjects = removeBadSubjectsFromList(list_subjects, goodSubjectsIndices);

% grab all data files in a well organized structure
% list files for all data_names from all subjects
isSomeFieldsEmpty = 0;
for ii = 1:length(listGoodSubjects)
    s_idx = listGoodSubjects{ii};

    % check every field
    for fn = 1:length(data_names)
	fieldname = data_names{fn};
	list_data(ii).(fieldname) = getFilesMatchingName(fieldname, [src_dir, s_idx, '/']);
	isSomeFieldsEmpty = isSomeFieldsEmpty || isempty(list_data(ii).(fieldname)); % OR: once switched to 1, will stay 1
    end
end
clear fieldname fn ii s_idx

isDataMissing = 0;
if(isSomeFieldsEmpty) warning('Some data is missing !'); isDataMissing = isSomeFieldsEmpty;  end

clear; close all; clc;

% [list_data, list_subjects, isDataMissing] = makeSubjectAndDataLists(partOfSubjDirName, src_dir, data_names)

addpath ./comp_struct/

good_src_dir_case1 = './makeSubjectAndDataLists_TEST/case1_data_complete/';
good_src_dir_case2 = './makeSubjectAndDataLists_TEST/case2_data_incomplete/';

good_data_names = {'data', 'file'};
goodSubjIndices = [1 2];

% Assuming it will never happen that two directories or two names match

total = 0;
passed = 0;
%% ERRORS - first argument

try
    [list_data, list_subjects, isDataMissing] = makeSubjectAndDataLists(2, good_src_dir_case1, good_data_names);
catch
    passed = passed + 1;
end
total = total + 1;

try
    [list_data, list_subjects, isDataMissing] = makeSubjectAndDataLists(1.7, good_src_dir_case1, good_data_names);
catch
    passed = passed + 1;
end
total = total + 1;

try
    [list_data, list_subjects, isDataMissing] = makeSubjectAndDataLists([], good_src_dir_case1, good_data_names);
catch
    passed = passed + 1;
end
total = total + 1;

try
    [list_data, list_subjects, isDataMissing] = makeSubjectAndDataLists({}, good_src_dir_case1, good_data_names);
catch
    passed = passed + 1;
end
total = total + 1;

try
    [list_data, list_subjects, isDataMissing] = makeSubjectAndDataLists('', good_src_dir_case1, good_data_names);
catch
    passed = passed + 1;
end
total = total + 1;

%% ERRORS - Second argument

try
    [list_data, list_subjects, isDataMissing] = makeSubjectAndDataLists('Sub_', [], good_data_names);
catch
    passed = passed + 1;
end
total = total + 1;

try
    [list_data, list_subjects, isDataMissing] = makeSubjectAndDataLists('Sub_', 5, good_data_names);
catch
    passed = passed + 1;
end
total = total + 1;

try
    [list_data, list_subjects, isDataMissing] = makeSubjectAndDataLists('Sub_', 1.6, good_data_names);
catch
    passed = passed + 1;
end
total = total + 1;

try
    [list_data, list_subjects, isDataMissing] = makeSubjectAndDataLists('Sub_', 'fooooo', good_data_names);
catch
    passed = passed + 1;
end
total = total + 1;

try
    [list_data, list_subjects, isDataMissing] = makeSubjectAndDataLists('Sub_', {'rubbish'}, good_data_names);
catch
    passed = passed + 1;
end
total = total + 1;

%% TRICKY - Second argument
try
    [list_data, list_subjects, isDataMissing] = makeSubjectAndDataLists('Sub_', '', good_data_names);
catch
    passed = passed + 1;
end
total = total + 1;

try
    [list_data, list_subjects, isDataMissing] = makeSubjectAndDataLists('Sub_', '.', good_data_names);
catch
    passed = passed + 1;
end
total = total + 1;


%% Third argument

try
[list_data, list_subjects, isDataMissing] = makeSubjectAndDataLists('Sub_', good_src_dir_case1, [], goodSubjIndices)
catch
    passed = passed + 1;
end
total = total + 1;

try
[list_data, list_subjects, isDataMissing] = makeSubjectAndDataLists('Sub_', good_src_dir_case1, '', goodSubjIndices)
catch
    passed = passed + 1;
end
total = total + 1;

try
[list_data, list_subjects, isDataMissing] = makeSubjectAndDataLists('Sub_', good_src_dir_case1, {}, goodSubjIndices)
catch
    passed = passed + 1;
end
total = total + 1;

try
[list_data, list_subjects, isDataMissing] = makeSubjectAndDataLists('Sub_', good_src_dir_case1, {'yeah'}, goodSubjIndices)
passed = passed + 1;
catch
end
total = total + 1;

try
[list_data, list_subjects, isDataMissing] = makeSubjectAndDataLists('Sub_', good_src_dir_case1, 'yeah', goodSubjIndices)
passed = passed + 1;
catch
end
total = total + 1;

try
[list_data, list_subjects, isDataMissing] = makeSubjectAndDataLists('Sub_', good_src_dir_case1, {'data', 'yeah'}, goodSubjIndices)
passed = passed + 1;
catch
end
total = total + 1;

%% reverse order of data_names

try
[list_data, list_subjects, isDataMissing] = makeSubjectAndDataLists('Sub_', good_src_dir_case1, {'data', 'file'}, goodSubjIndices)
passed = passed + 1;
catch
end
total = total + 1;


%% check case 1 - complete data

try
[list_data, list_subjects, isDataMissing] = makeSubjectAndDataLists('Sub_', good_src_dir_case1, {'file', 'data'}, goodSubjIndices)
exp_list_data(1).data   = {'data_1.mat'};
exp_list_data(2).data   = {'data_2.mat'};
exp_list_data(1).file   = {'file_1.mat'};
exp_list_data(2).file   = {'file_2.mat'};
[~, diff1, diff2]       = comp_struct(list_data, exp_list_data);
assert(isempty(diff1) && isempty(diff2))
exp_list_subjects       = {'Sub_1', 'Sub_2'};
assert(isequal(sort(list_subjects), sort(exp_list_subjects)))
assert(isDataMissing == 0)
passed = passed + 1;
total = total + 1;
catch
    total = total + 1;
end




%% check case 2 - incomplete data
try
[list_data, list_subjects, isDataMissing] = makeSubjectAndDataLists('Sub_', good_src_dir_case2, {'file', 'data'}, goodSubjIndices)
exp_list_data(1).data   = {'data_1.mat'};
exp_list_data(1).file   = {'file_1.mat'};
exp_list_data(2).file   = {'file_2.mat'};
exp_list_data(2).data   = [];
[~, diff1, diff2]       = comp_struct(list_data, exp_list_data);
assert(isempty(diff1) && isempty(diff2))
exp_list_subjects       = {'Sub_1', 'Sub_2'};
assert(isequal(sort(list_subjects), sort(exp_list_subjects)))
assert(isDataMissing == 1)
passed = passed + 1;
total = total + 1;
catch
    total = total + 1;
end


%% SUMMARY
disp(['Tests finished. Passed ', num2str(passed), ' / ', num2str(total), '.']);

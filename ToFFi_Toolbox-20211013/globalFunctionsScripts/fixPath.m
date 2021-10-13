function p2 = fixPath(p)
%%
% 1. Substitues every backslash (\) in the path p with a forward slash (/).
%
% 2. Adds trailing slash at the end if needed (if it is a file with
%    extension it omits this step to prevent from things like 'sth.txt/')
%% INPUT
% *p* - char array with path to the directory or file (need not to exist)
%% OUTPUT
% *p2* - char array with corrected path
%%

% change slash direction
p2 = p;
p2(strfind(p,'\')) = '/';

% add trailing slash if needed
[~, ~, ext] = fileparts(p2);
if(isempty(ext)) % only if it is file with extension !
    switch p2(end)
        case '/'
        otherwise
            p2 = [p2, '/'];
    end
end
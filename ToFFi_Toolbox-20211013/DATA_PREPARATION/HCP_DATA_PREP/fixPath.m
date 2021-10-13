function p2 = fixPath(p)
%%
% 1. Substitues every backslash (\) in the path p with forward slashes (/).
%
% 2. Adds trailing slash at the end if needed.
%%

% change slash direction
p2 = p;
p2(strfind(p,'\')) = '/';

% add trailing slash if needed
switch p2(end)
    case '/'
    otherwise
        p2 = [p2, '/'];
end
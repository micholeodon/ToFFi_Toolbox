function isInt = isInteger(x)
%%
% Checks if input argument is an integer.
%%
if(~isa(x, 'numeric')) 
    error('Input is not numerical !'); 
end
isInt = (mod(x,1) == 0);

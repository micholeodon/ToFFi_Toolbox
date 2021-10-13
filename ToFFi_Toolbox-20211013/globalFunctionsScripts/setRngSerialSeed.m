function [testVec, stream] = setRngSerialSeed(baseSeed)
%%
% Sets seed of the random number generator (Mersenne Twister) for serial code
% blocks to *baseSeed* or current time (when *baseSeed* == 'time').
% This function should be used outside parfor/spmd blocks.
%% Inputs
% *baseSeed* - double; integer from interval 0 to 2^32-1 thats serves as seed.
%
%% Outputs
% *testVec* - double; array of numbers that was drawn from the set generator
%
% *stream* - single random number generator stream that was set
%            (https://www.mathworks.com/help/matlab/ref/randstream.html)
%
%%

% check if it is positive integer within possible seed range or is 'time'
try
    if(strcmp(baseSeed, 'time'))
	stream = RandStream('mt19937ar','Seed','shuffle');
	testVec = finishSetting(stream);

    elseif( (baseSeed > 0) && ...
	    (baseSeed == round(baseSeed)) && ...
	    (baseSeed <= 2^32-1) )

	stream = RandStream('mt19937ar','Seed', baseSeed);
	testVec = finishSetting(stream);

    else
	error(['ERROR: Wrong baseSeed argument type! (should be nonnegative ' ...
	       'integer or ''time'') '])
    end
catch
    error(['ERROR: Wrong baseSeed argument type! (should be nonnegative ' ...
	   'integer or ''time'') '])
end


end


function testVec = finishSetting(s)
   RandStream.setGlobalStream(s);
   testVec = randn(1,5);
end

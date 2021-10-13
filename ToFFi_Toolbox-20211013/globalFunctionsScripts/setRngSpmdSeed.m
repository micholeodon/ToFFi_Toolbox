function [testVec, stream] = setRngSpmdSeed(baseSeed, iWorker, nWorkers)
%%
% Sets seed of the random number generator (Mersenne Twister) for parallel code
% blocks so each worker gets unique stream of random numbers based on
% *baseSeed* or current time (when *baseSeed* == 'time').
% This function should be used INSIDE parfor/spmd blocks.
%% Inputs
% *baseSeed* - double (integer from interval 0 to 2^32-1 thats serves as seed)
%              or
%              char ('time' to get current time value to serve as seed).
%
% *iWorker* - index of worker / CPU core / parallel processing unit.
%
% *nWorkers* - total number of workers / CPU cores / parallel
%              processing units in currently opened parallel pool
%              (https://www.mathworks.com/help/parallel-computing/parpool.html)
%% Outputs
% *testVec* - double; array of numbers that was drawn from the set generator
%
% *stream* - single random number generator stream that was set for worker
%            that called this function.
%            More about random streams:
%            (https://www.mathworks.com/help/matlab/ref/randstream.html)
%
%%

% check if it is positive integer within possible seed range or is 'time'
try
    if(strcmp(baseSeed, 'time'))

	stream = RandStream.create('mrg32k3a', 'NumStreams', nWorkers, ...
				   'Seed', 'shuffle', ...
				   'StreamIndices', iWorker);

	testVec = finishSetting(stream);

    elseif( (baseSeed > 0) && ...
	    (baseSeed == round(baseSeed)) && ...
	    (baseSeed <= 2^32-1) )

	stream = RandStream.create('mrg32k3a', 'NumStreams', nWorkers, ...
				   'Seed', baseSeed, ...
				   'StreamIndices', iWorker);

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

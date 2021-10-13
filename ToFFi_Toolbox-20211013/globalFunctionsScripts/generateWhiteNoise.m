function noise = generateWhiteNoise(S,N)
%% Inputs
%
% *S* - double; integer number of sources/channels
% *N* - double; integer number of samples of noise to be generated
%
%% Outputs
%
% *noise* - double; 2D-array gaussian white noise signal of size *S* x *N*.
% In each row expected value equals zero and variance equals 1;
%%

noise = randn(S,N);

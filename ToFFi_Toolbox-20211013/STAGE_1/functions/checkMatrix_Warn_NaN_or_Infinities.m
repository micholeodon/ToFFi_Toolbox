function checkMatrix_Warn_NaN_or_Infinities(cfg, dataMatrix)
%%
% Check if data stored in the input matrix contains NaNs or Infs.
%% Inputs
% *dataMatrix* - array;
%
% *cfg* - char; can equal [] or contain an arbitrary and possibly informative
%         name of the input matrix *dataMatrix*.
%
%%

% At some stages of preprocessing some weird values can appear.

reshaped        = reshape(dataMatrix, 1, []);

if(any(isnan(reshaped)))
    warning([cfg.name, ': contains NaNs !']);
end

if(any(isinf(reshaped)))
    warning([cfg.name, ': contains Infinities (Inf) !']);
end

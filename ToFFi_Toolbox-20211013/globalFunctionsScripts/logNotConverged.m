function  logNotConverged(cfg)
% Function appends into special .csv file ROI IDs and/or subject IDs for
% which Gaussian Mixture Modelling not converged (clustering for
% Individual/Group Spectral Fingerprints). Each call of this function appends
% single line to the output file.
%
% CAUTION !!! Remember to delete the file each time you do new analysis so it
% won't append to file related to previous analysis !!!
%% Inputs
% *cfg.colNames* - cell array of columns names, e.g. {'iROI', 'iSub', 'iIter'}
%
% *cfg.colValues* - values to append for each column
%
% *cfg.logPath* - path the log file (will be created if not exist) concatenated
%               with optional prefix, e.g. cfg.logPath = '/mydir/' or
%               cfg.logPath = '/mydir/myprefix' 
%% Outputs
% Output file structure:
%
% colName1, colName2, ..., colNameK
% val11, val12, ..., val1K
% val21, val22, ..., val2K
% ...
% valM1, valM2, ..., valMK
%%

if(numel(cfg.colNames) ~= numel(cfg.colValues))
    error(['Number of column names not match number of column values ' ...
           '!'])
end

logfile = [fixPath(cfg.logPath), 'NOTCONVERGED.csv'];

try
    if(~exist(logfile, 'file'))
        % create file
        fileID = fopen(logfile,'w');

        % create column headers
        for iCol = 1:numel(cfg.colNames)
            fprintf(fileID, '%s,', cfg.colNames{iCol});
        end
        fprintf(fileID, '\n');
    else
        fileID = fopen(logfile,'a+');
    end

    % append to file
    for iCol = 1:numel(cfg.colNames)
        fprintf(fileID, '%d,', cfg.colValues(iCol));
    end
    fprintf(fileID, '\n');

    fclose(fileID);
catch
    warning(['WARNING! There was a problem with NOTCONVERGED.csv file ! Probably  ' ...
             'some of its entires are lost.'])

    try
        % try to display on screen instead of file
        for iCol = 1:numel(cfg.colNames)
            sprintf('%s,', cfg.colNames{iCol});
        end
        for iCol = 1:numel(cfg.colNames)
            fprintf('%d,', cfg.colValues(iCol));
        end
    catch
        % do nothing
    end
end

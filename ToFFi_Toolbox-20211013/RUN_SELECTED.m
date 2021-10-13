clear; close all; clc;

% stages to be ran
stages=[1 2 3 4 5 6 7 8];


%%
p = pwd();


for iStage = stages
    cd(['STAGE_', num2str(iStage), '/scripts/'])
    RUN

    % run integration for selected stages
    if(ismember(iStage, [2 4 6]))
        INTEGRATE
    end

    cd(p)
end

disp 'ALL DONE !'
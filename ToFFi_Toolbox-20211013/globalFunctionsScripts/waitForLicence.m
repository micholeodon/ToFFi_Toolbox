function waitForLicence(pauseTime, toolboxName)
%%
% Waits until licence for selected toolbox is available.
%% Inputs
% pauseTime - time to wait between licence checks, e.g.: = 30  which is 30 s
%
% toolboxName - name of the toolbox which licence will be checked, e.g.:
%               'Distrib_Computing_Toolbox'
%%

while (~license('checkout', toolboxName))
    % do nothing and wait
    disp('Waiting for the licence')
    pause(pauseTime)
end

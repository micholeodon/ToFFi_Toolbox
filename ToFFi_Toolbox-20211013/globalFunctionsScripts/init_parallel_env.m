%%
% Script used to init parpool when Distributed Computing Toolbox is available.
%%
waitForLicence(30, 'Distrib_Computing_Toolbox');

profileName     = 'local';
nWorkers        = CFG.Global.maxNumSpmdWorkers;
initParpool(profileName, nWorkers);

waitForLicence(30, 'Distrib_Computing_Toolbox');

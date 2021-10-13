function  clusterConfig = initParpool(profileName, nWorkers)
%%
% Init parpool with specified profile name ( e.g. profileName = 'local')
% and number of workers (*nWorkers*).
%%
clusterConfig               = parcluster(profileName);
clusterConfig.NumWorkers    = nWorkers;
delete(gcp('nocreate')) % delete any previous parallel pool if exists
parpool(clusterConfig, clusterConfig.NumWorkers); % use all cores

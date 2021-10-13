% according to megconnectome 3.0 pipeline (from hcp_bfblpenv.m)

cfg = [];
cfg.covariance = 'yes';
cfg.keeptrials = 'no';
cfg.removemean = 'yes'; 
cfg.vartrllength =  2;
datavg = ft_timelockanalysis(cfg, data);

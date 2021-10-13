load('../output/CFG.mat')  % stage config contains global config parameters
addpath ../functions;
addGlobalFunctions(CFG.Global)
setupFieldtrip(CFG.Global)
MODE = CFG.(STAGE_NAME).MODE;
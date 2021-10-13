%% USER SETTINGS (EDITS ALLOWED) %%%%%%%%%%%%%%%%%%%%%%%%

inputDataPath = 'C:\johndoe\HCP_data\';
fieldTripPath = 'C:\johndoe\fieldtrip-20210816\';

nSub = 10; % number of subjects to load from inputDataPath


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%% (DO NOT EDIT)
%% add paths

inputDataPath = fixPath(inputDataPath);
fieldTripPath = fixPath(fieldTripPath);

addpath(fieldTripPath)
addpath ../../../globalFunctionsScripts/

ft_defaults

%% dir data
p_df  = inputDataPath;

af = dir(p_df);
af([1 2]) = []

cnt = 0;
for ff = 1:length(af)

    if(~regexp(af(ff).name, '\d{6}'))
        continue;
    end
    cnt = cnt +1;
    subFolders_LIST{cnt} = af(ff).name;
    
end
disp ok
subFolders_LIST

%%
outputPath = '../output/';

if(~exist(outputPath, 'dir'))
    mkdir(outputPath)
end

%% valid HCP subjects codes (89 MEG subjects) 

% subjCodes = {'100307','102816','105923','106521','108323','109123','111514', ...
%     '112920','113922','116524','116726','133019','140117','146129','149741', ...
%     '153732','154532','156334','158136','162026','162935','164636','166438', ...
%     '169040','172029','174841','175237','175540','177746','179245','181232', ...
%     '185442','187547','189349','191033','191437','191841','192641','195041', ...
%     '198653','204521','205119','212318','212823','214524','221319','223929', ...
%     '233326','248339','250427','255639','257845','283543','287248','293748', ...
%     '352132','352738','353740','358144','406836','433839','512835','555348', ...
%     '559053','568963','581450','599671','601127','660951','662551','665254', ...
%     '667056','679770','680957','706040','707749','715950','725751','735148', ...
%     '783462','814649','825048','872764','877168','891667','898176','912447', ...
%     '917255','990366'};
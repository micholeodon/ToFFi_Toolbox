indfname = ['finished_Sub', num2str(iSub), '_Rep', num2str(iRep), '.mat'];
indVar.iSub = iSub;
indVar.iRep = iRep;
indVar.time = datetime(now, 'ConvertFrom', 'datenum');
save(['../output/', indfname], 'indVar')

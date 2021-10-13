prefix      = 'individualFingerprint_';
thingSuffix = ['iROI', num2str(iROI), '_iSub', num2str(iSub)];
fname       = [prefix, thingSuffix];
tmp_folder  = '../output/not_integrated/';
mkdir(tmp_folder);
save([tmp_folder, '/', fname, '.mat'], 'individualFingerprintSingleROI');

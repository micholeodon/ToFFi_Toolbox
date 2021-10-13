% load tempalte mri single subject to interpolate onto (subroutine of showOn3dBrain)

disp('Reading MRI ...')
mrifile = [fieldtripPath 'template/anatomy/single_subj_T1.nii'];
mri = ft_read_mri(mrifile);
mri.coordsys = 'mni'; % to prevent manual fixing of coordsys
%ft_sourceplot([],mri)

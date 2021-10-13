singleRoiData.lvl1_numCentroidsPerSubject   = pooledClusters(iROI).numCentroidsPerSubject;
singleRoiData.lvl1_centroidsFromAllSubjects = pooledClusters(iROI).centroidsAllSubjects;
singleRoiData.lvl1_centroidsSubjectIndices  = pooledClusters(iROI).centroidsSubjectIndices;
singleRoiData.lvl1_centroidsDuration        = pooledClusters(iROI).centroidsDuration;
singleRoiData = rmfield(singleRoiData, {'numCentroidsPerSubject',...
		    'centroidsAllSubjects','centroidsSubjectIndices','centroidsDuration'});

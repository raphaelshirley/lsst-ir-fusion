#!/bin/bash
#source /rfs/project/rfs-L33A9wsNuJk/shared/lsst_stack_v21/loadLSST.bash
source /home/ir-shir1/rds/rds-iris-ip005/ras81/lsst_stack/loadLSST.bash
setup lsst_distrib
setup obs_vista
eups admin clearLocks

for i in {2..3594}
do 
  varArray="$(python jobDict.py $i w03_images_job_dict_3595.json)"
  varArray=($varArray)
  dateObs=${varArray[0]}
  numObs=${varArray[1]}
  filter=${varArray[2]}
  tracts=${varArray[3]}
  filename=${varArray[4]}
  echo "Ingesting:"
  echo $dateObs
  echo $numObs
  echo $filter
  echo $tracts
  echo $filename
  echo ${filename:53}
  echo ../../../dmu0/dmu0_VISTA/dmu0_VIKING/data/${filename:53}
  ~/mc cp iris/vista/${filename:53} ../../../dmu0/dmu0_VISTA/dmu0_VIKING/data/${filename:53}
  ingestImages.py ../data ../../../dmu0/dmu0_VISTA/dmu0_VIKING/data/${filename:53} --ignore-ingested 
done
#processCcd.py ../data --rerun processCcdOutputs --id dateObs=$dateObs numObs=$numObs --clobber-config
#makeCoaddTempExp.py ../data --rerun coadd --selectId dateObs=$dateObs numObs=$numObs filter=$filter --id filter=$filter tract=$tracts  --clobber-config

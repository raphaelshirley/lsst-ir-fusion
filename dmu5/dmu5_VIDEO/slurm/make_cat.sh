#!/bin/bash
#source /rfs/project/rfs-L33A9wsNuJk/shared/lsst_stack/loadLSST.bash
#source /Users/rs548/GitHub/lsst_stack/loadLSST.bash
source /home/ir-shir1/rds/rds-iris-ip005/ras81/lsst_stack/loadLSST.bash
setup lsst_distrib
setup obs_vista
eups admin clearLocks

python make_cat.py $1 ../../../dmu4/dmu4_VIDEO/slurm/sxds_patch_job_dict_219.json

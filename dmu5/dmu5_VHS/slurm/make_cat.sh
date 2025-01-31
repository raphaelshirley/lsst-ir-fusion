#!/bin/bash
#source /rfs/project/rfs-L33A9wsNuJk/shared/lsst_stack/loadLSST.bash
source /home/ir-shir1/rds/rds-iris-ip005/ras81/lsst_stack/loadLSST.bash
#source /Users/raphaelshirley/Documents/github/lsst_stack/loadLSST.bash
setup lsst_distrib
setup obs_vista
eups admin clearLocks
repo=/home/ir-shir1/rds/rds-iris-ip005/ras81/lsst-ir-fusion/dmu4/dmu4_VHS/data
varArray="$(python jobDict.py $1 $2)"
varArray=($varArray)
tract=${varArray[0]}
patch=${varArray[1]}

for filter in G R I Z Y
do
    cp -r ../../../dmu0/dmu0_HSC/data/hsc-release.mtk.nao.ac.jp/archive/filetree/pdr2_wide/deepCoadd-results/HSC-$filter/$tract/$patch/calexp*.fits $repo/rerun/coadd/deepCoadd-results/HSC-$filter/$tract/$patch/
done

python make_cat.py $1 $2

rm $repo/rerun/coadd/deepCoadd-results/HSC*/$tract/$patch/calexp-HSC*.fits

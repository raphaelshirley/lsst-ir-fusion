#!/bin/bash
source /home/ir-shir1/rds/rds-iris-ip005/ras81/lsst-ir-fusion/setup.sh

/usr/bin/time -o trace -a -f '%C %M kb %e s' jupyter nbconvert --to notebook --execute --ExecutePreprocessor.timeout=-1 ../3_Download_missing_det_files.ipynb --ExecutePreprocessor.kernel_name=lsst

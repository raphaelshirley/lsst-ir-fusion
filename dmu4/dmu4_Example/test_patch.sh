#!/bin/bash
source /Users/rs548/GitHub/lsst_stack/loadLSST.bash
setup lsst_distrib
setup obs_vista
#ingestImages.py data /Users/rs548/GitHub/lsst-ir-fusion/dmu0/dmu0_VISTA/dmu0_VIDEO/data/*/*_st.fit --clobber-config
#
#processCcd.py data --rerun processCcdOutputs --id --clobber-config

#Lets just run the one tract for now
#subset:
#tract=8524 patch=3,3^4,3^5,3^3,4^4,4^5,4^3,5^4,5^5,5
#Full patches for the test sxds tiles: 
#tract=8523 patch==0,2^0,3^0,4^0,5^0,6^0,7^0,8
#tract=8524 patch=2,2^2,3^2,4^2,5^2,6^2,7^2,8^3,2^3,3^3,4^3,5^3,6^3,7^3,8^4,2^4,3^4,4^4,5^4,6^4,7^4,8^5,2^5,3^5,4^5,5^5,6^5,7^5,8^6,2^6,3^6,4^6,5^6,6^6,7^6,8^7,2^7,3^7,4^7,5^7,6^7,7^7,8^8,2^8,3^8,4^8,5^8,6^8,7^8,8
makeSkyMap.py data --rerun processCcdOutputs:coadd --clobber-config
makeCoaddTempExp.py data --rerun coadd --selectId filter=VISTA-Y --id filter=VISTA-Y tract=8524 patch=3,5 --clobber-config
makeCoaddTempExp.py data --rerun coadd --selectId filter=VISTA-J --id filter=VISTA-J tract=8524 patch=3,5 --clobber-config
makeCoaddTempExp.py data --rerun coadd --selectId filter=VISTA-H --id filter=VISTA-H tract=8524 patch=3,5 --clobber-config
makeCoaddTempExp.py data --rerun coadd --selectId filter=VISTA-Ks --id filter=VISTA-Ks tract=8524 patch=3,5 --clobber-config
#Then we assemble the coadds 
assembleCoadd.py data --rerun coadd --selectId filter=VISTA-Y --id filter=VISTA-Y tract=8524 patch=3,5 --clobber-config
assembleCoadd.py data --rerun coadd --selectId filter=VISTA-J --id filter=VISTA-J tract=8524 patch=3,5 --clobber-config
assembleCoadd.py data --rerun coadd --selectId filter=VISTA-H --id filter=VISTA-H tract=8524 patch=3,5 --clobber-config
assembleCoadd.py data --rerun coadd --selectId filter=VISTA-Ks --id filter=VISTA-Ks tract=8524 patch=3,5 --clobber-config

#Then detect sources 
detectCoaddSources.py data --rerun coadd:coaddPhot --id filter=VISTA-Y tract=8524 patch=3,5 --clobber-config
detectCoaddSources.py data --rerun coadd:coaddPhot --id filter=VISTA-J tract=8524 patch=3,5 --clobber-config
detectCoaddSources.py data --rerun coadd:coaddPhot --id filter=VISTA-H tract=8524 patch=3,5 --clobber-config
detectCoaddSources.py data --rerun coadd:coaddPhot --id filter=VISTA-Ks tract=8524 patch=3,5 --clobber-config

mkdir -p data/rerun/coaddPhot/deepCoadd-results/
cp -r /Users/rs548/GitHub/lsst-ir-fusion/dmu0/dmu0_HSC/data/hsc-release.mtk.nao.ac.jp/archive/filetree/pdr2_dud/deepCoadd-results/* data/rerun/coaddPhot/deepCoadd-results/
#Merge any detection catalogues VISTA-Y^VISTA-Ks^HSC-R
mergeCoaddDetections.py data --rerun coaddPhot --id filter=VISTA-Ks tract=8524 patch=3,5 --clobber-config

deblendCoaddSources.py data --rerun coaddPhot --id filter=VISTA-Y tract=8524 patch=3,5 --clobber-config
deblendCoaddSources.py data --rerun coaddPhot --id filter=VISTA-J tract=8524 patch=3,5 --clobber-config
deblendCoaddSources.py data --rerun coaddPhot --id filter=VISTA-H tract=8524 patch=3,5 --clobber-config
deblendCoaddSources.py data --rerun coaddPhot --id filter=VISTA-Ks tract=8524 patch=3,5 --clobber-config
deblendCoaddSources.py data --rerun coaddPhot --id filter=HSC-G tract=8524 patch=3,5 --clobber-config
deblendCoaddSources.py data --rerun coaddPhot --id filter=HSC-R tract=8524 patch=3,5 --clobber-config
deblendCoaddSources.py data --rerun coaddPhot --id filter=HSC-I tract=8524 patch=3,5 --clobber-config
deblendCoaddSources.py data --rerun coaddPhot --id filter=HSC-Z tract=8524 patch=3,5 --clobber-config
deblendCoaddSources.py data --rerun coaddPhot --id filter=HSC-Y tract=8524 patch=3,5 --clobber-config
# measure positions (before this stage detections are given interms of pixel footprints
measureCoaddSources.py data --rerun coaddPhot --id filter=VISTA-Y tract=8524 patch=3,5 --clobber-config
measureCoaddSources.py data --rerun coaddPhot --id filter=VISTA-H tract=8524 patch=3,5 --clobber-config
measureCoaddSources.py data --rerun coaddPhot --id filter=VISTA-J tract=8524 patch=3,5 --clobber-config
measureCoaddSources.py data --rerun coaddPhot --id filter=VISTA-Ks tract=8524 patch=3,5 --clobber-config
measureCoaddSources.py data --rerun coaddPhot --id filter=HSC-G tract=8524 patch=3,5 --clobber-config
measureCoaddSources.py data --rerun coaddPhot --id filter=HSC-R tract=8524 patch=3,5 --clobber-config
measureCoaddSources.py data --rerun coaddPhot --id filter=HSC-I tract=8524 patch=3,5 --clobber-config
measureCoaddSources.py data --rerun coaddPhot --id filter=HSC-Z tract=8524 patch=3,5 --clobber-config
measureCoaddSources.py data --rerun coaddPhot --id filter=HSC-Y tract=8524 patch=3,5 --clobber-config
mergeCoaddMeasurements.py data --rerun coaddPhot --id filter=VISTA-Y^VISTA-J^VISTA-H^VISTA-Ks^HSC-G^HSC-R^HSC-I^HSC-Z^HSC-Y tract=8524 patch=3,5 --clobber-config

forcedPhotCoadd.py data --rerun coaddPhot:coaddForcedPhot --id filter=VISTA-Y tract=8524 patch=3,5 --clobber-config
forcedPhotCoadd.py data --rerun coaddForcedPhot --id filter=VISTA-J tract=8524 patch=3,5 --clobber-config
forcedPhotCoadd.py data --rerun coaddForcedPhot --id filter=VISTA-H tract=8524 patch=3,5 --clobber-config
forcedPhotCoadd.py data --rerun coaddForcedPhot --id filter=VISTA-Ks tract=8524 patch=3,5 --clobber-config
forcedPhotCoadd.py data --rerun coaddForcedPhot --id filter=HSC-G tract=8524 patch=3,5 --clobber-config
forcedPhotCoadd.py data --rerun coaddForcedPhot --id filter=HSC-R tract=8524 patch=3,5 --clobber-config
forcedPhotCoadd.py data --rerun coaddForcedPhot --id filter=HSC-I tract=8524 patch=3,5 --clobber-config
forcedPhotCoadd.py data --rerun coaddForcedPhot --id filter=HSC-Z tract=8524 patch=3,5 --clobber-config
forcedPhotCoadd.py data --rerun coaddForcedPhot --id filter=HSC-Y tract=8524 patch=3,5 --clobber-config
#!/bin/bash
#source /home/ir-shir1/rds/rds-iris-ip005/ras81/lsst_stack/loadLSST.bash
#source /Users/raphaelshirley/Documents/github/lsst_stack/loadLSST.bash
#setup obs_vista 23.0.0-1
#setup lsst_distrib -t w_2022_07
source /Users/raphaelshirley/Documents/github/lsst-ir-fusion/setup_mac.sh

export repo=data

if [ -f $repo/butler.yaml ]; then
    rm -rf $repo
fi

if [ ! -f $repo/butler.yaml ]; then
    #rm -r $repo
    butler create $repo
    #butler register-instrument $repo lsst.obs.subaru.HyperSuprimeCam
    butler register-instrument $repo lsst.obs.vista.VIRCAM
    #Make and register the all sky skymap using local config file
    butler register-skymap $repo -C "$OBS_VISTA_DIR/config/makeSkyMap.py"
    
    # Import the reference catalogues to the butler.
    butler register-dataset-type $repo ps1_pv3_3pi_20170110_vista SimpleCatalog htm7
    cp -r ../../dmu2/data/video_gen3 $repo  # VIDEO ref
    butler ingest-files -t direct $repo ps1_pv3_3pi_20170110_vista refcats data/video_gen3/filename_to_htm.ecsv 
    #cp -r ../../dmu2/data/g3_2mass $repo  # 2MASS ref
    #butler ingest-files -t direct $repo ps1_pv3_3pi_20170110_vista refcats data/g3_2mass/filename_to_htm.ecsv 
    
    #Ingest the raw exposures _st for stacks [0-9] for exposures
    butler ingest-raws $repo ../../dmu0/dmu0_VISTA/dmu0_VIDEO/data/*/*_st.fit -t copy --output-run VIRCAM/raw/video
    #butler ingest-raws $repo ../../dmu0/dmu0_VISTA/dmu0_VIDEO/data/20121122/v20121122_00088_st.fit -t copy
    #Define the visits from the ingested exposures
    butler define-visits $repo VIRCAM 
    #We don't have calibs but we need the collection for later processing
    butler write-curated-calibrations $repo VIRCAM
fi

#Import confidence maps
#butler import $repo "../../dmu0/dmu0_VISTA/dmu0_VIDEO" --export-file "../../dmu0/dmu0_VISTA/dmu0_VIDEO/export_test.yaml" 
butler register-dataset-type $repo confidence ExposureF instrument band physical_filter exposure detector
butler ingest-files --formatter=lsst.obs.vista.VircamRawFormatter $repo confidence confidence/video ../../dmu0/dmu0_VISTA/dmu0_VIDEO/test_export_confidence.ecsv -t copy

#pipetask run -d "exposure=658653 AND detector=10" -b $repo --input videoConfidence,VIRCAM/raw/all,refcats,VIRCAM/calib --register-dataset-types -p "$OBS_VISTA_DIR/pipelines/DRP_full.yaml#singleFrame" --output videoSingleFrame  

#Run processCcd on some exposures singleFrame processCcd
pipetask run -d "detector IN (9,10) AND band IN ('J','K')" -b $repo --input confidence/video,VIRCAM/raw/video,refcats,VIRCAM/calib --register-dataset-types -p "$OBS_VISTA_DIR/pipelines/DRP_full.yaml#singleFrame" --output videoSingleFrame   #--extend-run --clobber-outputs --skip-existing

#Coadd the exposures
pipetask run -d "tract=8524 AND patch IN (39,48) AND skymap='hscPdr2' " -b $repo --input confidence/video,skymaps,VIRCAM/raw/video,refcats,VIRCAM/calib,videoSingleFrame  --register-dataset-types -p "$OBS_VISTA_DIR/pipelines/DRP_full.yaml#coaddDetect" --output videoCoaddDetect

#Import HSC deepCoadd images and detections
#These must be ingested into a RUN collection so we ls it from the coadd collection 
#coaddRun=$(ls $repo/videoCoaddDetect)
coaddRun=hscImports
butler ingest-files --formatter=lsst.obs.base.formatters.fitsExposure.FitsExposureFormatter $repo deepCoadd videoCoaddDetect/$coaddRun ../../dmu0/dmu0_HSC/data/calexp_2.ecsv
butler ingest-files --formatter=lsst.obs.base.formatters.fitsExposure.FitsExposureFormatter $repo deepCoadd_calexp videoCoaddDetect/$coaddRun ../../dmu0/dmu0_HSC/data/calexp_2.ecsv
butler ingest-files --formatter=lsst.obs.base.formatters.fitsGeneric.FitsGenericFormatter $repo deepCoadd_det videoCoaddDetect/$coaddRun ../../dmu0/dmu0_HSC/data/det_2.ecsv

#Run photometry pipeline
pipetask run -d "tract=8524 AND patch IN (39,48) AND skymap='hscPdr2' " -b $repo --input confidence/video,VIRCAM/raw/video,refcats,VIRCAM/calib,skymaps,videoSingleFrame,videoCoaddDetect,videoCoaddDetect/$coaddRun --register-dataset-types -p "$OBS_VISTA_DIR/pipelines/DRP_full.yaml#multiVisitLater" --output videoMultiVisitLater


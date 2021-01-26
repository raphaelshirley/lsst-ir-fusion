from astropy.table import Table,vstack
import glob
import os

if os.getcwd()=='/Users/rs548/GitHub/lsst-ir-fusion/dmu5/dmu5_SXDS/slurm':
    BUTLER_LOC = '/Volumes/Raph500/lsst-ir-fusion/dmu4/dmu4_Example/data'
    DATA = '/Volumes/Raph500/lsst-ir-fusion/dmu5/dmu5_Example/data'
else:
    BUTLER_LOC = '../../../dmu4/dmu4_SXDS/data'
    DATA =  '../data'
#butler =  dafPersist.Butler(inputs='{}/rerun/coaddForcedPhot'.format(BUTLER_LOC))

red_cats = glob.glob(DATA+'/reduced*.fits')

full_cat = Table()
for r in red_cats:
    try:
        t= Table.read(r)
        mask = t['VISTA-Ks_f_detect_isPatchInner'] & t['VISTA-Ks_f_detect_isTractInner']
        full_cat=vstack([full_cat,t[mask]])
    except:
        print(r,' failed')
full_cat.write(DATA+'/full_reduced_cat_SXDS.fits', overwrite=True)

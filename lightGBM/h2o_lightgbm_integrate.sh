#!/usr/bin/bash

# ----------------------------------------------------------------------------
#
# Package       : LightGBM
# Version       : 2.2.4
# Description:  : This script integrates native cuda enabled lighgbm package into 
#                 the H2O installation specified in this script 
# Source repo for lightgbm   	: https://github.com/bordaw/LightGBM-CUDA
# iSource repo for this script	: https://github.com/ppc64le/build-scripts/tree/master/lightGBM/h2o_lightgbm_integrate.sh
# Tested on     : RHEL_7.6
# Script License: Apache License, Version 2 or later
# Maintainer    : Hari Reddy <hnreddy@us.ibm.com>
#
# Disclaimer: This script has been tested in non-root mode on given
# ==========  platform using the mentioned version of the package.
#             It may not work as expected with newer versions of the
#             package and/or distribution. In such case, please
#             contact "Maintainer" of this script.
#
# ----------------------------------------------------------------------------

#  Please follow these steps to build and integrate cuda enabled lightgbm into H2o installation
#  Step 1: Download and run the following script in non-root mode with sudo capability  to build LighGBM_CUDA
#  	   https://github.com/ppc64le/build-scripts/tree/master/lightGBM/lightGBM_rhel_cuda.sh    
#  Step 2: cd to  ...../LighGBM_CUDA   directory
#  
#  Step 3: Download  the following script into the LighTGBM-CUDA directory and make changes to the script
#          to point to the right H2O installation
#	   https://github.com/ppc64le/build-scripts/tree/master/lightGBM/h2o_lightgbm_integrate.sh
#  Step 4: run h2o_lightgbm_integrate.sh
#          Make sure the lig_lightgbm.so file is copied to the proper location
#          Example:   dai-1.8.0-linux-ppc64le/cuda-10.0/lib/python3.6/site-packages/lightgbm_cpu/lib_lightgbm.so


CURRENT_DIR=$(pwd)
LIGHTGBM_DIR=$CURRENT_DIR/python-package
H2O_BASE=/h2o/hari/h2o/cuda/dai-1.8.0-linux-ppc64le/ # H2o installation directory 
H2O_LIGHTGBM=$H2O_BASE/cuda-10.0 # H2O cuda package directory for lighgbm
LIGHTGBM_PKG_DIR=$H2O_LIGHTGBM/lib/python3.6/site-packages
cd $LIGHTGBM_PKG_DIR
rm -rf lightgbm*
cd $LIGHTGBM_DIR
rm -rf dist
rm -rf build
rm -rf compile
$H2O_BASE/dai-env.sh python  setup.py sdist bdist_wheel

 cd dist
 $H2O_BASE/dai-env.sh pip install --prefix=$H2O_LIGHTGBM ./lightgbm*.whl
 echo "$H2O_BASE/dai-env.sh pip install --prefix=$H2O_LIGHTGBM ./lightgbm*.whl"

 cd $LIGHTGBM_PKG_DIR
 for f in $(ls -d lightgbm*);do
     n=${f//lightgbm/lightgbm_cpu}
	     mv $f $n
		 done
		 cd lightgbm*info
		 sed -i 's/^lightgbm/lightgbm_cpu/g' RECORD

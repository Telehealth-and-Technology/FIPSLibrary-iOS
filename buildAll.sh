PROJECTPATH=`pwd`

# This sets up environment vars to point to which openssl/fips we cant to use
. ./setEnvOpensslFiles.sh
. ./buildAllDevice.sh
. ./buildAllSim.sh

echo ""
echo "-----------------------------------------"
echo " Now building and installing final fat lib files"
echo "-----------------------------------------"

cd $PROJECTPATH

# Set _LIB_SIM_CRYPTO and _LIB_DEVICE_CRYPTO based on whether or not libcrypto.a exists in directories
[[ -s ${PROJECTPATH}/devSim/libi386/libcrypto.a ]] && _LIB_SIM_CRYPTO=${PROJECTPATH}/devSim/libi386/libcrypto.a  || _LIB_SIM_CRYPTO=""
[[ -s ${PROJECTPATH}/dev/libarmv7/libcrypto.a ]] && _LIB_DEVICE_CRYPTO=${PROJECTPATH}/dev/libarmv7/libcrypto.a || _LIB_DEVICE_CRYPTO=""



# _LIB_SIM_CRYPTO=${PROJECTPATH}/devSim/libcrypto.a
# _LIB_SIM_SSL=${PROJECTPATH}/devSim/src/$OPENSSL_BASE/libssl.a 

# _LIB_DEVICE_CRYPTO=${PROJECTPATH}/dev/$OPENSSL_BASE/libcrypto.a
# _LIB_DEVICE_SSL=${PROJECTPATH}/dev/$OPENSSL_BASE/libssl.a


echo "_LIB_SIM_CRYPTO = $_LIB_SIM_CRYPTO"
echo "_LIB_DEVICE_CRYPTO = $_LIB_DEVICE_CRYPTO"

# Create the fat file
# *** Note: we're using the tool lipo here. The problem is that lipo changed locations from xcode 4x to 5x and is dependent on if you have
# mavricks or not. To side step this issue we store a known good copy of the tool (iphoneoslipo) in CMS to use here

if test ! -z "$_LIB_SIM_CRYPTO" || test ! -z "$_LIB_DEVICE_CRYPTO";  then
    echo "command line = ./iphoneoslipo -create $_LIB_SIM_CRYPTO  $_LIB_DEVICE_CRYPTO -output ./libcrypto.a" 
    ./iphoneoslipo -create $_LIB_SIM_CRYPTO  $_LIB_DEVICE_CRYPTO -output ./libcrypto.a
    cp ./libcrypto.a $INSTALL_DIR
else
    echo "No libaraies to create fat file from!"

fi







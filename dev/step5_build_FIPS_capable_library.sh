# Copyright � 2009-2015 United States Government as represented by
# the Chief Information Officer of the National Center for Telehealth
# and Technology. All Rights Reserved.

# Copyright � 2009-2015 Contributors. All Rights Reserved.

# THIS OPEN SOURCE AGREEMENT ("AGREEMENT") DEFINES THE RIGHTS OF USE,
# REPRODUCTION, DISTRIBUTION, MODIFICATION AND REDISTRIBUTION OF CERTAIN
# COMPUTER SOFTWARE ORIGINALLY RELEASED BY THE UNITED STATES GOVERNMENT
# AS REPRESENTED BY THE GOVERNMENT AGENCY LISTED BELOW ("GOVERNMENT AGENCY").
# THE UNITED STATES GOVERNMENT, AS REPRESENTED BY GOVERNMENT AGENCY, IS AN
# INTENDED THIRD-PARTY BENEFICIARY OF ALL SUBSEQUENT DISTRIBUTIONS OR
# REDISTRIBUTIONS OF THE SUBJECT SOFTWARE. ANYONE WHO USES, REPRODUCES,
# DISTRIBUTES, MODIFIES OR REDISTRIBUTES THE SUBJECT SOFTWARE, AS DEFINED
# HEREIN, OR ANY PART THEREOF, IS, BY THAT ACTION, ACCEPTING IN FULL THE
# RESPONSIBILITIES AND OBLIGATIONS CONTAINED IN THIS AGREEMENT.

# Government Agency: The National Center for Telehealth and Technology
# Government Agency Original Software Designation: T2Crypto
# Government Agency Original Software Title: T2Crypto
# User Registration Requested. Please send email
# with your contact information to: robert.a.kayl.civ@mail.mil
# Government Agency Point of Contact for Original Software: robert.a.kayl.civ@mail.mil

#---------------------------------------------------------
# Builds FIPS Capable library (Using T2's fipscanister.o)
#---------------------------------------------------------

echo ""
echo "#---------------------------------------------------------"
echo "# Step 5 build FIPS Capable library"
echo "#---------------------------------------------------------"


cd $T2_BUILD_DIR
mkdir lib$T2_BUILD_PLATFORM

# ========================================
# First, set up environment variables 
# (Make and config use these)
# ========================================


# clear out any old environment variables
. ./setenv-reset.sh

# Define local variables
CROSS_TYPE=OS   
MACHINE="iphone"  
CROSS_ARCH="armv7"
PLATFORM=$MACHINE$CROSS_TYPE
CROSS_DEVELOPER=`xcode-select -print-path`      

          
     
# CROSS_SDK is the SDK version being used - adjust as appropriate
# Note: This next line needs to be updated whenever a new IOS sdk is used with this build system
for i in 9.0 8.1 7.1 5.1 5.0 4.3 do
do
  if [ -d "$CROSS_DEVELOPER/Platforms/$MACHINE$CROSS_TYPE.platform//Developer/SDKs/$MACHINE$CROSS_TYPE"$i".sdk" ]; then
    SDKVER=$i
    break
  fi
done     


# CROSS_TOP is the top of the development tools tree
# Note is isysroot is created as such in .config: isysroot = ${CROSS_TOP}/SDKs/${CROSS_SDK}

#define global environment variables (make and config use these)
export CROSS_TOP="${CROSS_DEVELOPER}/Platforms/${PLATFORM}.platform/Developer"   
export SDKVERSION=$SDKVER
export CROSS_SDK=$MACHINE"$CROSS_TYPE""$SDKVER".sdk
export BUILD_TOOLS="${CROSS_DEVELOPER}"
export CC="${BUILD_TOOLS}/usr/bin/gcc -arch ${CROSS_ARCH}"
     

CURRENTPATH=`pwd`
set -e

 tar zxf $OPENSSL_BASE.tar.gz -C "${CURRENTPATH}"
 cd "${CURRENTPATH}/$OPENSSL_BASE"

 echo ""
 echo "Building $OPENSSL_BASE for ${PLATFORM} ${SDKVERSION} ${CROSS_ARCH}"
 echo ""

. $PROJECTPATH/echoVars.sh
EchoVars "(arm64 build - 64 bit device, Step 5 build FIPS Capable library"

# ========================================
# Now build the component
# ========================================
set -e

# cofigure builds the makefile (Based on makefile.org and input parameters) 
# that will be used to build the FIPS library
# --with-fipsdir=$INSTALL_DIR tells the build to use T2's fipscanister.o
./Configure iphoneos-cross fips --with-fipsdir=$INSTALL_DIR


if [ $? != 0 ];
then 
    echo "Problem while configure - Please check ${LOG}"
    exit 1
fi


# xcode 9+ requires the target ios version
sed -ie "s!^CFLAG=!CFLAG=-miphoneos-version-min=7.0 !" "Makefile"

make build_libs

if [ $? != 0 ];
then 
    echo "Problem while make - Please check ${LOG}"
    exit 1
fi
          



# copy the lib to the intermediate lib directory
cp libcrypto.a ../lib$T2_BUILD_PLATFORM

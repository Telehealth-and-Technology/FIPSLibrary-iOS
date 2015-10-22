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

#-------------------------------------------------------------------
# Builds the fipscanister module
#-------------------------------------------------------------------

echo ""
echo "#---------------------------------------------------------"
echo "# Step 3 build FIPS Object Module"
echo "#---------------------------------------------------------"


# move to fips' dir
cd $T2_BUILD_DIR/$FIPS_BASE

# ========================================
# First, set up environment variables 
# (Make and config use these)
# ========================================

# clear out any old
. ../setenv-reset.sh

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
  if [ -d "$CROSS_DEVELOPER/Platforms/iPhone$CROSS_TYPE.platform//Developer/SDKs/iPhone$CROSS_TYPE"$i".sdk" ]; then
    SDKVER=$i
    break
  fi
done

# CROSS_TOP is the top of the development tools tree
# Note is isysroot is created as such in .config: isysroot = ${CROSS_TOP}/SDKs/${CROSS_SDK}

#define global environment variables (make and config use these)
export CROSS_TOP="${CROSS_DEVELOPER}/Platforms/${PLATFORM}.platform/Developer"   
export SDKVERSION=$SDKVER
export CROSS_SDK=iPhone"$CROSS_TYPE""$SDKVER".sdk

#
# fips/sha/Makefile uses HOSTCC for building fips_standalone_sha1
#
export HOSTCC=/usr/bin/cc
export HOSTCFLAGS="-arch i386"

# CROSS_COMPILE is the prefix for the tools - in this case the scripts
# which invoke the tools with the correct options for 'fat' binary handling
export CROSS_COMPILE="`pwd`"/iOS/

# FIPS_SIG is the tool for determining the incore fingerprint
#export FIPS_SIG=/usr/local/ssl/fingerprint-macho
export FIPS_SIG="`pwd`"/iOS/incore_macho

#
# these remain to be cleaned up ... 
#
export IOS_TARGET=darwin-iphoneos-cross
export IOS_INSTALLDIR=/usr/local/ssl/Release-iphoneos

#
# definition for uname output for cross-compilation
#
MACHINE=`echo "-$CROSS_ARCH" | sed -e 's/^-//'`
SYSTEM="iphoneos"
BUILD="build"

export MACHINE
export SYSTEM
export BUILD


# adjust the path to ensure we always get the correct tools
export PATH="`pwd`"/iOS:$PATH

# make incore_macho available to build
export PATH="/usr/local/bin":$PATH


# for iOS we have not plugged in ASM or SHLIB support so we disable
# those options for now
export CONFIG_OPTIONS="no-asm no-shared --openssldir=$IOS_INSTALLDIR"


. $PROJECTPATH/echoVars.sh
EchoVars "(arm64 build - 64 bit device, Step 3 build FIPS Object Module)"



# ========================================
# Now build the component
# ========================================
make clean
rm -f *.dylib

# XCode 7.0 and above requires that miphoneos-version-min be spedified in all compiles
LC_ALL=C sed -ie 's/-DOPENSSL_THREADS/-DOPENSSL_THREADS -miphoneos-version-min=7.0/' "Configure"

# configure and make
./config
make



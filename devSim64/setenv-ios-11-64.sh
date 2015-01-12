#
# setenv-macho.sh
#

#
# depending on whether or not we are using the simulator or the real
# device we have slightly different paths which are determined entirely
# by the CROSS_TYPE setting - either Simulator or OS
#
#cross_arch="-armv7"
#export CROSS_TYPE=OS
export CROSS_TYPE=Simulator
cross_arch="x86_64"

##CROSS_DEVELOPER=`xcode-select -print-path`
CROSS_DEVELOPER="/Applications//Xcode.app/Contents/Developer"

# CROSS_TOP is the top of the development tools tree
export CROSS_TOP="/Applications/Xcode.app/Contents/Developer/Platforms/iPhone$CROSS_TYPE.platform/Developer"

# CROSS_CHAIN is the location of the actual compiler tools
#export CROSS_CHAIN="$CROSS_TOP"/usr/bin/

# CROSS_SDK is the SDK version being used - adjust as appropriate
# for 4.3 or 5.0 (default)
for i in 8.1 7.1 5.1 5.0 4.3 do
do
  if [ -d "$CROSS_DEVELOPER/Platforms/iPhone$CROSS_TYPE.platform//Developer/SDKs/iPhone$CROSS_TYPE"$i".sdk" ]; then
    SDKVER=$i
    break
  fi
done

export CROSS_SDK=iPhone"$CROSS_TYPE""$SDKVER".sdk

#
# fips/sha/Makefile uses HOSTCC for building fips_standalone_sha1
#
export HOSTCC=/usr/bin/cc
export HOSTCFLAGS="-arch x86_64"

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
cross_type=`echo $CROSS_TYPE | tr '[A-Z]' '[a-z]'`
#SYSTEM="iphone"$cross_type"$cross_arch-cross"
#MACHINE="darwin"
#BUILD="build"

MACHINE=`echo "$cross_arch" | sed -e 's/^-//'`
SYSTEM="iphoneos"
BUILD="build"

export MACHINE
export SYSTEM
export BUILD

echo "MACHINE = " $MACHINE
echo "SYSTEM = " $SYSTEM
echo "BUILD = " $BUILD
echo "KERNEL_BITS = " $KERNEL_BITS

# adjust the path to ensure we always get the correct tools
export PATH="`pwd`"/iOS:$PATH

# for iOS we have not plugged in ASM or SHLIB support so we disable
# those options for now
export CONFIG_OPTIONS="no-asm no-shared --openssldir=$IOS_INSTALLDIR"


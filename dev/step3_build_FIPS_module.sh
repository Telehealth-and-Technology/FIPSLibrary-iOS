# move to fips' dir
cd $T2_BUILD_DIR/$FIPS_BASE

make clean
rm -f *.dylib


# make incore_macho available to build
export PATH="/usr/local/bin":$PATH


# setup environment
. ../setenv-reset.sh
. ../setenv-ios-11.sh

#  TODO tmp for testing
# Due to a problem with the newer os-x tools the simulator (not the device) build fails the fips signature check
# For now we'll disable this check (for the simulator only)
# Note that this breaks fips compiliance for the simulator but we're still fips compliant with the actual device build
#sed -ie 's/FIPS_check_incore_fingerprint(void)/FIPS_check_incore_fingerprint(void) {return 1;}  int dummy(void)/' "./fips/fips.c"

# XCode 7.0 and above requires that miphoneos-version-min be spedified in all compiles
 LC_ALL=C sed -ie 's/-DOPENSSL_THREADS/-DOPENSSL_THREADS -miphoneos-version-min=7.0/' "Configure"


# configure and make
./config fipscanisterbuild
make



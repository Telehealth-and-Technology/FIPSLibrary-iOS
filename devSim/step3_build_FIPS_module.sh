#---------------------------------------------------------
# build FIPS Object Module
#---------------------------------------------------------

# move to fips' dir
cd $T2_BUILD_DIR/$FIPS_BASE

make clean
rm -f *.dylib

pwd
. ../setenv-reset.sh
. ../setenv-ios-11.sh

# XCode 7.0 and above requires that miphoneos-version-min be spedified in all compiles
 LC_ALL=C sed -ie 's/-DOPENSSL_THREADS/-DOPENSSL_THREADS -miphoneos-version-min=7.0/' "Configure"


echo "-------------------------Build log make"
# .config creates the makefile (based on makefile.fips) that will be used to build the container
./config fipscanisterbuild
make


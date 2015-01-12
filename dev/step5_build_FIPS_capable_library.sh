#---------------------------------------------------------
# build FIPS Capable library
#---------------------------------------------------------

# move to Source dir
cd $T2_BUILD_DIR
mkdir lib$T2_BUILD_PLATFORM

# make incore_macho available to build
export PATH="/usr/local/bin":$PATH

# delete old artifacts
rm -Rf $OPENSSL_BASE/

# unpack fresh files
tar xzf $OPENSSL_BASE.tar.gz 

# move to ssl' dir
cd $OPENSSL_BASE/

# remove references to ERR_load_COMP_strings in err_all.c
sed  s/ERR_load_COMP_strings\(\)\;// <crypto/err/err_all.c >crypto/err/err_all.c.new
mv crypto/err/err_all.c.new crypto/err/err_all.c

# setup environment
. ../setenv-reset.sh
. ../setenv-ios-11.sh

# configure and make FIPS Capable library
./config fips -no-shared -no-comp -no-dso -no-hw -no-engines -no-sslv2 -no-sslv3 --with-fipsdir=$INSTALL_DIR
make build_libs

# copy the lib to the intermediate lib directory
cp libcrypto.a ../lib$T2_BUILD_PLATFORM
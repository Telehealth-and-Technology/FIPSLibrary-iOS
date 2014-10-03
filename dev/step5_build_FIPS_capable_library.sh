#---------------------------------------------------------
# build FIPS Capable library
#---------------------------------------------------------

# move to Source dir
cd dev
mkdir libarmv7

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
./config fips -no-shared -no-comp -no-dso -no-hw -no-engines -no-sslv2 -no-sslv3 --with-fipsdir=/usr/local/ssl/Release-iphoneos
make build_libs

# copy the lib to the intermediate lib directory
cp libcrypto.a ../libarmv7
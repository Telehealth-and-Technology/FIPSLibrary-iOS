#---------------------------------------------------------
# build FIPS Object Module
#---------------------------------------------------------

# move to Source dir
cd dev

# delete old artifacts
rm -Rf $FIPS_BASE/

# make incore_macho available to build
export PATH="/usr/local/bin":$PATH

# unpack fresh files

tar xzf $FIPS_BASE.tar.gz

#tar xzf ios-incore-2.0.2.tar
#unpack incore tools to a sub-sirectory in the fips directory
cp -r SupplementalFiles/iOSIncoreTools/iOS $FIPS_BASE

# move to fips' dir
cd $FIPS_BASE

# setup environment
. ../setenv-reset.sh
. ../setenv-ios-11.sh

# configure and make
./config
make



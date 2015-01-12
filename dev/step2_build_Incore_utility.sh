#---------------------------------------------------------
# steps to build the Incore utility 
#---------------------------------------------------------

# move to Source dir
cd $T2_BUILD_DIR

# delete old artifacts
rm -Rf $FIPS_BASE/

# unpack fresh files
tar xzf $FIPS_BASE.tar.gz

#unpack incore tools to a sub-sirectory in the fips directory
cp -r SupplementalFiles/iOSIncoreTools/iOS $FIPS_BASE

# setup environment
. ./setenv-reset.sh
. ./setenv-darwin-i386.sh

# verify paths set by darwin script
env

# move to fips' dir
cd $FIPS_BASE


# configure and make
./config
make

# move to incore's dir and make
cd iOS/
make






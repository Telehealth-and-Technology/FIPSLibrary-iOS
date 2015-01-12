#---------------------------------------------------------
# steps to build the Incore utility 
#---------------------------------------------------------

# move to Source dir
cd $T2_BUILD_DIR

#extract the fips code base into devSim direcgtory
tar xzf $FIPS_BASE.tar.gz

#unpack incore tools to a sub-sirectory in the fips directory
cp -r SupplementalFiles/iOSIncoreTools/iOS $FIPS_BASE

# setup environment for os-x for build the incore utility
# this utility is used by the applicaition build process to embed the fips fingerprint into 
# the final executable
. ./setenv-reset.sh
. ./setenv-darwin-i386.sh


# move to fips' dir
cd $FIPS_BASE

# configure and make fips module for incore utility
./config fipscanisterbuild
make

# make the incore utility with the fips module just built
cd iOS/
make

# copy the infore utility to local bin dirt
cp ./incore_macho /usr/local/bin



# # Clean up
# cd ..
# make clean
# rm -f *.dylib

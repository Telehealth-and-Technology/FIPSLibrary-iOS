echo ""
echo "#---------------------------------------------------------"
echo "# step 2 to build the Incore utility "
echo "#---------------------------------------------------------"

# move to Source dir
cd $T2_BUILD_DIR

# get a fresh copy of fips module source 
tar xzf $FIPS_BASE.tar.gz

#unpack incore tools to a sub-sirectory in the fips directory
cp -r ../SupplementalFiles/iOSIncoreTools/iOS $FIPS_BASE

# setup environment for os-x for build the incore utility
# this utility is used by the applicaition build process to embed the fips fingerprint into 
# the final executable
. ./setenv-reset.sh
. ./setenv-darwin-64.sh


# move to fips' dir
cd $FIPS_BASE
echo "FIPS_BASE = " $FIPS_BASE

make clean

# configure and make fips module for incore utility
./Configure darwin64-x86_64-cc

# now build the fips module
make

# now make the incore utility with the fips module just built
cd iOS/
make

if [ $? != 0 ];
then 
    echo "Problem while make - Please check ${LOG}"
    exit 1
fi


echo "Copying ./incore_macho /usr/local/bin"
# copy the infore utility to local bin dir
cp ./incore_macho /usr/local/bin


# Clean up
cd ..
make clean


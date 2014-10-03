#---------------------------------------------------------
# install FIPS Object Module
#
# /usr/local/ssl/Release-iphoneos/
#---------------------------------------------------------

# move to Source dir
cd devSim

# move to fips' dir
cd $FIPS_BASE

# install - may require root...

echo "-------------------------Build log make install"
make install


# delete artifacts
# rm -Rf $FIPS_BASE/

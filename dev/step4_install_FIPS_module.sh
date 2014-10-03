#---------------------------------------------------------
# install FIPS Object Module
#
# /usr/local/ssl/Release-iphoneos/
#---------------------------------------------------------

# move to Source dir
cd dev

# move to fips' dir
cd $FIPS_BASE

# install - may require root...
make install

# delete artifacts
rm -Rf $FIPS_BASE/

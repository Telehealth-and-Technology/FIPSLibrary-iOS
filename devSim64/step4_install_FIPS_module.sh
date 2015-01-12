echo ""
echo "#---------------------------------------------------------"
echo "# Step 4 install FIPS Object Module"
echo "#"
echo "# Installs to $INSTALL_DIR (/usr/local/ssl/Release-iphoneos/)"
echo "#---------------------------------------------------------"

# move to Source directory 
cd $T2_BUILD_DIR

# move to fips' dir
cd $FIPS_BASE

# install - may require root...

echo "-------------------------Build log make install"
make install


# delete artifacts
# rm -Rf $FIPS_BASE/

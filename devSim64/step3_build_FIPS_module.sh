echo ""
echo "echo "#---------------------------------------------------------""
echo "echo "# Step 3 build FIPS Object Module""
echo "echo "#---------------------------------------------------------""

# move to fips' dir
cd $T2_BUILD_DIR/$FIPS_BASE

make clean
rm -f *.dylib

pwd
. ../setenv-reset.sh
. ../setenv-ios-11-64.sh


# XCode 7.0 and above requires that miphoneos-version-min be spedified in all compiles
 LC_ALL=C sed -ie 's/-DOPENSSL_THREADS/-DOPENSSL_THREADS -miphoneos-version-min=7.0/' "Configure"


echo "-------------------------Build log make"
./Configure darwin64-x86_64-cc --openssldir=$IOS_INSTALLDIR
 make


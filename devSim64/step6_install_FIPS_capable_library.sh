echo ""
echo "#---------------------------------------------------------"
echo "# Step 6install FIPS Capable library"
echo "#---------------------------------------------------------"

# move to Source dir
cd $T2_BUILD_DIR

# move to ssl' dir
cd $OPENSSL_BASE/

# setup environment
. ../setenv-reset.sh
. ../setenv-ios-11-64.sh

FIPSDIR=$INSTALL_DIR
INCDIR=$INSTALL_DIR/include/openssl

# install - may require root...
# libraries

# Don't copy these next 2, wait until we create a fat file from them in buildAll.sh then copy them
# cp libssl.a $FIPSDIR
# cp libcrypto.a $FIPSDIR


# headers
cp crypto/stack/stack.h     $INCDIR
cp crypto/stack/safestack.h $INCDIR
cp crypto/err/err.h         $INCDIR
cp crypto/bio/bio.h         $INCDIR
cp crypto/lhash/lhash.h     $INCDIR
cp crypto/rand/rand.h       $INCDIR
cp crypto/evp/evp.h         $INCDIR
cp crypto/objects/objects.h $INCDIR
cp crypto/objects/obj_mac.h $INCDIR
cp crypto/asn1/asn1.h       $INCDIR
cp crypto/ui/ui_compat.h 	$INCDIR
cp crypto/ui/ui_locl.h 		$INCDIR
cp crypto/ui/ui.h 			$INCDIR

# Copyright � 2009-2015 United States Government as represented by
# the Chief Information Officer of the National Center for Telehealth
# and Technology. All Rights Reserved.

# Copyright � 2009-2015 Contributors. All Rights Reserved.

# THIS OPEN SOURCE AGREEMENT ("AGREEMENT") DEFINES THE RIGHTS OF USE,
# REPRODUCTION, DISTRIBUTION, MODIFICATION AND REDISTRIBUTION OF CERTAIN
# COMPUTER SOFTWARE ORIGINALLY RELEASED BY THE UNITED STATES GOVERNMENT
# AS REPRESENTED BY THE GOVERNMENT AGENCY LISTED BELOW ("GOVERNMENT AGENCY").
# THE UNITED STATES GOVERNMENT, AS REPRESENTED BY GOVERNMENT AGENCY, IS AN
# INTENDED THIRD-PARTY BENEFICIARY OF ALL SUBSEQUENT DISTRIBUTIONS OR
# REDISTRIBUTIONS OF THE SUBJECT SOFTWARE. ANYONE WHO USES, REPRODUCES,
# DISTRIBUTES, MODIFIES OR REDISTRIBUTES THE SUBJECT SOFTWARE, AS DEFINED
# HEREIN, OR ANY PART THEREOF, IS, BY THAT ACTION, ACCEPTING IN FULL THE
# RESPONSIBILITIES AND OBLIGATIONS CONTAINED IN THIS AGREEMENT.

# Government Agency: The National Center for Telehealth and Technology
# Government Agency Original Software Designation: T2Crypto
# Government Agency Original Software Title: T2Crypto
# User Registration Requested. Please send email
# with your contact information to: robert.a.kayl.civ@mail.mil
# Government Agency Point of Contact for Original Software: robert.a.kayl.civ@mail.mil


#---------------------------------------------------------
# install FIPS Capable library
#---------------------------------------------------------

echo ""
echo "#---------------------------------------------------------"
echo "# Step 6 install FIPS Capable library"
echo "#---------------------------------------------------------"
#---------------------------------------------------------



cd $T2_BUILD_DIR

# move to ssl' dir
cd $OPENSSL_BASE/

# setup environment
. ../setenv-reset.sh

FIPSDIR=$INSTALL_DIR
INCDIR=$INSTALL_DIR/include/openssl

# install - may require root...
# libraries

# Don't copy these, wait until we create a fat file from them in buildAll.sh then copy them
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
cp crypto/ui/ui_compat.h    $INCDIR
cp crypto/ui/ui_locl.h      $INCDIR
cp crypto/ui/ui.h           $INCDIR

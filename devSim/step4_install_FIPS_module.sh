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
# install FIPS Object Module
#
# /usr/local/ssl/Release-iphoneos/
#---------------------------------------------------------

echo ""
echo "#---------------------------------------------------------"
echo "# Step 4 install FIPS Object Module"
echo "#---------------------------------------------------------"


# move to Source dir
cd $T2_BUILD_DIR

# move to fips' dir
cd $FIPS_BASE

# install - may require root...
make install

# delete artifacts
rm -Rf $FIPS_BASE/
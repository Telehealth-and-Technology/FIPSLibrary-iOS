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

# Change these to the openssl and FIPS files that you want to compile with
export OPENSSL_BASE=openssl-1.0.1f
export FIPS_BASE=openssl-fips-2.0.2
export INSTALL_DIR=/usr/local/ssl/Release-iphoneos

export PROJECTPATH=`pwd`

# Note: we're specifying simulator here but it doesn't matter because we're only using this to determine which sdk is present
CROSS_TYPE=Simulator
CROSS_DEVELOPER="/Applications//Xcode.app/Contents/Developer"

# dynamically determine which sdk to use
# CROSS_SDK is the SDK version being used - adjust as appropriate
# 8.1 (default)
for i in 8.1 7.1 5.1 5.0 4.3
	do

	  if [ -d "$CROSS_DEVELOPER/Platforms/iPhone$CROSS_TYPE.platform//Developer/SDKs/iPhone$CROSS_TYPE"$i".sdk" ]; then
	    SDKVER=$i
	    export SDKVERSION=$i
	    break

	  fi
	done

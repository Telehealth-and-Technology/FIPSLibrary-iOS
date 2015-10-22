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

#-------------------------------------------------------------------
# Builds the the incore_macho utility. This is a native program that 
# is used to confirm fingerprints
# (it's actually incore for macho file format)
# incore_macho loads the final executable and calculates the SHA1
# if the text and data segments of the fipscanister.o module
#-------------------------------------------------------------------

echo ""
echo "#---------------------------------------------------------"
echo "# Step 2 Build the the incore_macho utility"
echo "#---------------------------------------------------------"



# move to Source dir
cd $T2_BUILD_DIR

# delete old artifacts
rm -Rf $FIPS_BASE/

# unpack fresh files
tar xzf $FIPS_BASE.tar.gz

#unpack incore tools to a sub-sirectory in the fips directory
cp -r ../SupplementalFiles/iOSIncoreTools/iOS $FIPS_BASE

# setup environment
. ./setenv-reset.sh


# ========================================
# First, set up environment variables 
# (Make and config use these)
# ========================================
printEnv()
{
    echo ""    
    echo "-----------------------------------------------"
    echo "setenv-ios-11.sh environment variables  (armv7 build - 32 bit device)"
    echo "-----------------------------------------------"

    echo "MACHINE        = " $MACHINE
    echo "SYSTEM         = " $SYSTEM
    echo "KERNEL_BITS    = " $KERNEL_BITS
    echo "CONFIG_OPTIONS = " $CONFIG_OPTIONS    
    echo "PATH           = " $PATH    
    echo "-----------------------------------------------"    
    echo ""
}

SYSTEM="Darwin"
MACHINE="i386"
KERNEL_BITS=32

export MACHINE
export SYSTEM
export KERNEL_BITS

# adjust the path to ensure we always get the correct tools
export PATH="`pwd`"/iOS:$PATH


# ========================================
# Now build the component
# ========================================

# move to fips' dir
cd $FIPS_BASE

# configure and make
./config
make

# move to incore's dir and make
cd iOS/
make

# copy the infore utility to local bin dir
cp ./incore_macho /usr/local/bin

# Clean up
cd ..
make clean





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
# Evokes all steps to build platform library
#---------------------------------------------------------

LOGFILE=FIPS_buildSimulator$T2_BUILD_PLATFORM.log
echo "buildallSim$T2_BUILD_PLATFORM.sh"  1>$LOGFILE 2>&1

echo ""
echo "-----------------------------------------"
echo " Building $T2_BUILD_PLATFORM for IOS 32 bit Simulator"
echo " See logfile $LOGFILE"
echo "-----------------------------------------"


# This sets up environment vars to point to which openssl/fips we cant to use
. ./setEnvOpensslFiles.sh


  RETURN_CODE=0

  #----------------------------------------------------------------------
  echo "Step 1 remove quarantine"
  echo "Step 1 remove quarantine" 1>>$LOGFILE 2>&1
  #----------------------------------------------------------------------
  ./$T2_BUILD_DIR/step1_remove_Quarantine.sh 1>>$LOGFILE 2>&1

  #----------------------------------------------------------------------
      echo "Step 2 build and install Incore Utility"
      echo "Step 2 build and install Incore Utility" 1>>$LOGFILE 2>&1
  #----------------------------------------------------------------------
  ./$T2_BUILD_DIR/step2_build_Incore_utility.sh 1>>$LOGFILE 2>&1
  if [ $? != 0 ];
  then 
    echo "Problem building step 2 - See logfile $LOGFILE"
    exit 1
  fi

  #----------------------------------------------------------------------
  echo "Step 3 build FIPS Object Module"
  echo "Step 3 build FIPS Object Module" 1>>$LOGFILE 2>&1
  #----------------------------------------------------------------------
  ./$T2_BUILD_DIR/step3_build_FIPS_module.sh 1>>$LOGFILE 2>&1
  if [ $? != 0 ];
  then 
    echo "Problem building step 3 - See logfile $LOGFILE"
    exit 1
  fi

  #----------------------------------------------------------------------
  echo "Step 4 install FIPS Object Module to $INSTALL_DIR "
  echo "Step 4 install FIPS Object Module to $INSTALL_DIR " 1>>$LOGFILE 2>&1
  #----------------------------------------------------------------------
  ./$T2_BUILD_DIR/step4_install_FIPS_module.sh 1>>$LOGFILE 2>&1
  if [ $? != 0 ];
  then 
    echo "Problem building step 4 - See logfile $LOGFILE"
    exit 1
  fi

  #----------------------------------------------------------------------
  echo "Step 5 build FIPS Capable library"
  echo "Step 5 build FIPS Capable library" 1>>$LOGFILE 2>&1
  #----------------------------------------------------------------------
  ./$T2_BUILD_DIR/step5_build_FIPS_capable_library.sh 1>>$LOGFILE 2>&1
  if [ $? != 0 ];
  then 
    echo "Problem building step 5 - See logfile $LOGFILE"
    exit 1
  fi

  #----------------------------------------------------------------------
  echo "Step 6 install FIPS Capable library to $INSTALL_DIR "
  echo "Step 6 install FIPS Capable library to $INSTALL_DIR " 1>>$LOGFILE 2>&1
  #----------------------------------------------------------------------
  ./$T2_BUILD_DIR/step6_install_FIPS_capable_library.sh 1>>$LOGFILE 2>&1
    if [ $? != 0 ];
    then 
      echo "Problem building step 6 - See logfile $LOGFILE"
      exit 1
    fi



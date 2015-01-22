# Checks for missing downloaded files
#
# files are necessary from fips/openssl, and sqlcipher


LOGFILE=FIPS_buildSimulator$T2_BUILD_PLATFORM.log
echo "buildallSim$T2_BUILD_PLATFORM.sh"  1>$LOGFILE 2>&1

echo ""
echo "-----------------------------------------"
echo " Building $T2_BUILD_PLATFORM"
echo " See logfile $LOGFILE"
echo "-----------------------------------------"



# This sets up environment vars to point to which openssl/fips we cant to use
. ./setEnvOpensslFiles.sh

  # Switch to new (5.5 dev tools) for device build 
  sudo xcode-select --switch /Applications/Xcode.app

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



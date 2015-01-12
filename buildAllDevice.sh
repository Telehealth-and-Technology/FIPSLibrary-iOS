# Checks for missing downloaded files
#
# files are necessary from fips/openssl, and sqlcipher

LOGFILE=FIPS_build$T2_BUILD_PLATFORM.log
echo "buildall$T2_BUILD_PLATFORM.sh"  1>$LOGFILE 2>&1

echo ""
echo "-----------------------------------------"
echo " Building $T2_BUILD_PLATFORM"
echo " See logfile $LOGFILE"
echo "-----------------------------------------"




# This sets up environment vars to point to which openssl/fips we cant to use
. ./setEnvOpensslFiles.sh

 #----------------------------------------------------------------------
  #
  # Build iOS FIPS module and library
  #


  # Switch to old (4.6 dev tools) for device build 
  # Note that the 5.x xcode version of the tools DO NOT work when compiling for device!
  xcode-select --switch /XCode4.6/Xcode.app


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

    #----------------------------------------------------------------------
    echo "Step 3 build FIPS Object Module"
    echo "Step 3 build FIPS Object Module" 1>>$LOGFILE 2>&1
    #----------------------------------------------------------------------
    ./$T2_BUILD_DIR/step3_build_FIPS_module.sh 1>>$LOGFILE 2>&1
    if [ $? -eq 0 ] ; then
      RETURN_CODE=0
    else
      echo "\t***error***"
      RETURN_CODE=1
    fi

    if [ "$RETURN_CODE" -eq "0" ] ; then

    #----------------------------------------------------------------------
    echo "Step 4 install FIPS Object Module to $INSTALL_DIR "
    echo "Step 4 install FIPS Object Module to $INSTALL_DIR " 1>>$LOGFILE 2>&1
    #----------------------------------------------------------------------
    ./$T2_BUILD_DIR/step4_install_FIPS_module.sh 1>>$LOGFILE 2>&1

      if [ $? -eq 0 ] ; then
        RETURN_CODE=0
      else
        echo "\t***error***"
        RETURN_CODE=1
      fi
    fi

  if [ "$RETURN_CODE" -eq "0" ] ; then
  
    #----------------------------------------------------------------------
    echo "Step 5 build FIPS Capable library"
    echo "Step 5 build FIPS Capable library" 1>>$LOGFILE 2>&1
    #----------------------------------------------------------------------
    ./$T2_BUILD_DIR/step5_build_FIPS_capable_library.sh 1>>$LOGFILE 2>&1
      if [ $? -eq 0 ] ; then
        RETURN_CODE=0
      else
        echo "\t***error***"
        RETURN_CODE=1
      fi
    fi

  if [ "$RETURN_CODE" -eq "0" ] ; then
  #----------------------------------------------------------------------
  echo "Step 6 install FIPS Capable library to $INSTALL_DIR "
  echo "Step 6 install FIPS Capable library to $INSTALL_DIR " 1>>$LOGFILE 2>&1
  #----------------------------------------------------------------------
  ./$T2_BUILD_DIR/step6_install_FIPS_capable_library.sh 1>>$LOGFILE 2>&1

    if [ $? -ne 0 ] ; then
      echo "\t***error***"
    fi
  fi


# Checks for missing downloaded files
#
# files are necessary from fips/openssl, and sqlcipher

LOGFILE=FIPS_build.log
echo "buildallDevice.sh"  1>$LOGFILE 2>&1

echo ""
echo "-----------------------------------------"
echo " Building for IOS Device (armv7)"
echo "-----------------------------------------"




# This sets up environment vars to point to which openssl/fips we cant to use
. ./setEnvOpensslFiles.sh
echo "using $OPENSSL_BASE.tar.gz"
echo "using $FIPS_BASE.tar.gz"


# for testing we might want to automatically copy these files
# for production don't do this because we want to make sure the "official" files are used
cp localFipsSslFiles/*.gz ./dev


fipsSslFiles="1"
sqlCipherFiles="1"
  echo ""


# fips/openssl files
sslFiles="dev/$OPENSSL_BASE.tar.gz"
fipsFiles="dev/$FIPS_BASE.tar.gz"
#sqlFiles="dev/android-database-sqlcipher"


echo "sslFiles = $sslFiles"
echo "fipsFiles = $fipsFiles"

if [ ! -f "$sslFiles" ]; then
  echo "$sslFiles is missing!"
  fipsSslFiles=""
fi

if [ ! -f "$fipsFiles" ]; then
  echo "$fipsFiles is missing!"
  fipsSslFiles=""
fi

# # note we're just checking for the top level directory here - there should be LOTS of files under it
# if [ ! -d "$sqlFiles" ]; then
#   echo "$sqlFiles is missing!"
#     sqlCipherFiles=""
# fi


if [ ! -n "$fipsSslFiles" ]; then 

  echo ""
  echo "!!!! One or more of the fips download files are missing !!!!!"
  echo "" 
  echo "You have two options:"

  echo "Option 1 - get the official disk and copy $OPENSSL_BASE.tar.gz, and $FIPS_BASE.tar.gz to the dev directory"
  echo "Option 2 - copy the files from the local distribution (use command: copyLocalSshFiles.sh)"
  echo ""



else

  echo ""
  echo "*************************************************"
  echo "All download files are present and accounted for!"
  echo " Use command make buildAll"
  echo "*************************************************"

    read -p "press y to continue build " yn
    case $yn in
      [Yy]* ) 
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
      ./dev/step1_remove_Quarantine.sh 1>>$LOGFILE 2>&1

      #----------------------------------------------------------------------
      echo "Step 2 build and install Incore Utility"
      echo "Step 2 build and install Incore Utility" 1>>$LOGFILE 2>&1
      #----------------------------------------------------------------------
      ./dev/step2_build_Incore_utility.sh 1>>$LOGFILE 2>&1

      #----------------------------------------------------------------------
      echo "Step 3 build FIPS Object Module"
      echo "Step 3 build FIPS Object Module" 1>>$LOGFILE 2>&1
      #----------------------------------------------------------------------
      ./dev/step3_build_FIPS_module.sh 1>>$LOGFILE 2>&1
      if [ $? -eq 0 ] ; then
        RETURN_CODE=0
      else
        echo "\t***error***"
        RETURN_CODE=1
      fi

      if [ "$RETURN_CODE" -eq "0" ] ; then

      #----------------------------------------------------------------------
      echo "Step 4 install FIPS Object Module (/usr/local/ssl/Release-iphoneos/)"
      echo "Step 4 install FIPS Object Module (/usr/local/ssl/Release-iphoneos/)" 1>>$LOGFILE 2>&1
      #----------------------------------------------------------------------
      ./dev/step4_install_FIPS_module.sh 1>>$LOGFILE 2>&1

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
      ./dev/step5_build_FIPS_capable_library.sh 1>>$LOGFILE 2>&1

        if [ $? -eq 0 ] ; then
          RETURN_CODE=0
        else
          echo "\t***error***"
          RETURN_CODE=1
        fi
      fi

      if [ "$RETURN_CODE" -eq "0" ] ; then
      #----------------------------------------------------------------------
      echo "Step 6 install FIPS Capable library (/usr/local/ssl/Release-iphoneos/)"
      echo "Step 6 install FIPS Capable library (/usr/local/ssl/Release-iphoneos/)" 1>>$LOGFILE 2>&1
      #----------------------------------------------------------------------
      ./dev/step6_install_FIPS_capable_library.sh 1>>$LOGFILE 2>&1

        if [ $? -ne 0 ] ; then
          echo "\t***error***"
        fi
      fi

      ;;
      [Yn]* ) 
        echo "you chose no"

        ;;
      * ) echo "please choose";;
    esac




 




fi


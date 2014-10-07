# Checks for missing downloaded files
#
# files are necessary from fips/openssl, and sqlcipher

SDKVERSION="7.1"    

LOGFILE=FIPS_buildSimulator.log
echo "buildallSim.sh"  1>$LOGFILE 2>&1

echo ""
echo "-----------------------------------------"
echo " Building for IOS Simulator"
echo "-----------------------------------------"



# This sets up environment vars to point to which openssl/fips we cant to use
. ./setEnvOpensslFiles.sh

echo "using $OPENSSL_BASE.tar.gz"
echo "using $FIPS_BASE.tar.gz"


# for testing we might want to automatically copy these files
# for production don't do this because we want to make sure the "official" files are used
#cp localFipsSslFiles/*.gz ./devSim

fipsSslFiles="1"
sqlCipherFiles="1"
  echo ""


# fips/openssl files
sslFiles="devSim/$OPENSSL_BASE.tar.gz"
fipsFiles="devSim/$FIPS_BASE.tar.gz"
#sqlFiles="devSim/android-database-sqlcipher"


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

  echo "Option 1 - get the official disk and copy $OPENSSL_BASE.tar.gz, and $FIPS_BASE.tar.gz to the devSim directory"
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

        # Switch to new (5.5 dev tools) for device build 
        sudo xcode-select --switch /Applications/Xcode.app

        RETURN_CODE=0

        #----------------------------------------------------------------------
            echo "Step 2 build and install Incore Utility"
            echo "Step 2 build and install Incore Utility" 1>>$LOGFILE 2>&1
        #----------------------------------------------------------------------
        ./devSim/step2_build_Incore_utility.sh 1>>$LOGFILE 2>&1

          #----------------------------------------------------------------------
          echo "Step 3 build FIPS Object Module"
          echo "Step 3 build FIPS Object Module" 1>>$LOGFILE 2>&1
          #----------------------------------------------------------------------
          ./devSim/step3_build_FIPS_module.sh 1>>$LOGFILE 2>&1
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
          ./devSim/step4_install_FIPS_module.sh 1>>$LOGFILE 2>&1

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
          ./devSim/step5_build_FIPS_capable_library.sh 1>>$LOGFILE 2>&1
            if [ $? -eq 0 ] ; then
              RETURN_CODE=0
            else
              echo "\t***error***"
              RETURN_CODE=1
            fi
          fi





    esac

 fi


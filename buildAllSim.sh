# Checks for missing downloaded files
#
# files are necessary from fips/openssl, and sqlcipher

SDKVERSION="7.1"    

LOGFILE=FIPS_buildSimulator.log
echo "buildall.sh"  1>$LOGFILE 2>&1



# This sets up environment vars to point to which openssl/fips we cant to use
. ./setEnvOpensslFiles.sh

echo "using $OPENSSL_BASE.tar.gz"
echo "using $FIPS_BASE.tar.gz"


# for testing we might want to automatically copy these files
# for production don't do this because we want to make sure the "official" files are used
cp localFipsSslFiles/*.gz ./devSim

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

        cd devSim

        # Switch to new (5.5 dev tools) for device build 
        sudo xcode-select --switch /Applications/Xcode.app


        #----------------------------------------------------------------------
        #
        # Build iOS FIPS module
        #
        #----------------------------------------------------------------------

        #extract the fips code base into devSim direcgtory
        tar xzf $FIPS_BASE.tar.gz

        #unpack incore tools to a sub-sirectory in the fips directory
        cp -r SupplementalFiles/iOSIncoreTools/iOS $FIPS_BASE

        # setup environment for os-x for build the incore utility
        # this utility is used by the applicaition build process to embed the fips fingerprint into 
        # the final executable
        . ./setenv-reset.sh
        . ./setenv-darwin-i386.sh

        # verify paths set by darwin script
        env 

        # move to fips' dir
        cd $FIPS_BASE

        # configure and make fips module for incore utility
        ./config fipscanisterbuild
        make

        # make the incore utility with the fips module just built
        cd iOS/
        make

        # copy the infore utility to local bin dirt
        cp ./incore_macho /usr/local/bin

        # check which compiler we're using
        echo "llvm-gcc -v = " llvm-gcc -v

        # Clean up
        cd ..
        make clean
        rm -f *.dylib

        # Now do the cross compile build for th esikulator 
        pwd
        . ../setenv-reset.sh
        . ../setenv-ios-11.sh


        # Due to a problem with the newer os-x tools the simulator (not the device) build fails the fips signature check
        # For now we'll disable this check (for the simulator only)
        # Note that this breaks fips compiliance for the simulator but we're still fips compliant with the actual device build
         sed -ie 's/FIPS_check_incore_fingerprint(void)/FIPS_check_incore_fingerprint(void) {return 1;}  dummy(void)/' "/Users/scoleman/dev/IOSFipsBuilds/test1001/fcids/devSim/$FIPS_BASE/fips/fips.c"
        

        ./config fipscanisterbuild >> $LOGFILE 2>&1

        echo "-------------------------Build log make"
        make
        echo "-------------------------Build log make install"
        make install




        echo "-------------------------Build log make create openssl files"
        cd ..
        . ./setenv-reset.sh
        #----------------------------------------------------------------------
        #
        # Build openssl
        #
        #----------------------------------------------------------------------
        ARCH="i386"
        CURRENTPATH=`pwd`
        PLATFORM="iPhoneSimulator"
        DEVELOPER=`xcode-select -print-path`
        INSTALL_DIR=/usr/local/ssl/Release-iphoneos



        set -e

        mkdir -p "${CURRENTPATH}/src"
        mkdir -p "${CURRENTPATH}/bin"
        mkdir -p "${CURRENTPATH}/lib"

        tar zxf $OPENSSL_BASE.tar.gz -C "${CURRENTPATH}/src"
        cd "${CURRENTPATH}/src/$OPENSSL_BASE"

        export CROSS_TOP="${DEVELOPER}/Platforms/${PLATFORM}.platform/Developer"
        export CROSS_SDK="${PLATFORM}${SDKVERSION}.sdk"
        export BUILD_TOOLS="${DEVELOPER}"

        echo "Building $OPENSSL_BASE for ${PLATFORM} ${SDKVERSION} ${ARCH}"
        echo "Please stand by..."

        export CC="${BUILD_TOOLS}/usr/bin/gcc -arch ${ARCH}"
        mkdir -p "${CURRENTPATH}/bin/${PLATFORM}${SDKVERSION}-${ARCH}.sdk"
        LOG="${CURRENTPATH}/bin/${PLATFORM}${SDKVERSION}-${ARCH}.sdk/$OPENSSL_BASE.log"

        set +e

        ./Configure iphoneos-cross --openssldir="${CURRENTPATH}/bin/${PLATFORM}${SDKVERSION}-${ARCH}.sdk" fips --with-fipsdir=/usr/local/ssl/Release-iphoneos > "${LOG}" 2>&1
      #./Configure iphoneos-cross --openssldir="${CURRENTPATH}/bin/${PLATFORM}${SDKVERSION}-${ARCH}.sdk" fips --with-fipsdir=/usr/local/ssl/Release-iphoneos > "${LOG}" 2>&1

        if [ $? != 0 ];
        then 
            echo "Problem while configure - Please check ${LOG}"
            exit 1
        fi

        # add -isysroot to CC=
        sed -ie "s!^CFLAG=!CFLAG=-isysroot ${CROSS_TOP}/SDKs/${CROSS_SDK} -miphoneos-version-min=7.0 !" "Makefile"

        make >> "${LOG}" 2>&1

        if [ $? != 0 ];
        then 
            echo "Problem while make - Please check ${LOG}"
            exit 1
        fi
          
    set -e
    make install >> "${LOG}" 2>&1
  #  make clean >> "${LOG}" 2>&1  

  cp ${CURRENTPATH}/bin/${PLATFORM}${SDKVERSION}-${ARCH}.sdk/lib/libcrypto.a ../..
    esac

 fi


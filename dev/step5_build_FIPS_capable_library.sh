# #---------------------------------------------------------
# # build FIPS Capable library
# #---------------------------------------------------------

printEnv()
{
    echo ""
    echo "MACHINE = " $MACHINE
    echo "SYSTEM = " $SYSTEM
    echo "BUILD = " $BUILD
    echo "CROSS_ARCH = " $CROSS_ARCH
    echo "CROSS_TYPE = " $CROSS_TYPE
    echo "CROSS_DEVELOPER = " $CROSS_DEVELOPER
    echo "CROSS_TOP = " $CROSS_TOP
    echo "CROSS_CHAIN = " $CROSS_CHAIN
    echo "CROSS_SDK = " $CROSS_SDK
    echo "CROSS_SYSROOT = " $CROSS_SYSROOT
    echo "CROSS_COMPILE = " $CROSS_COMPILE
    echo "IOS_TARGET = " $IOS_TARGET
    echo "RELEASE = " $RELEASE
    echo "KERNEL_BITS = " $KERNEL_BITS
    echo "INSTALL_DIR = " $INSTALL_DIR
    echo "OPENSSL_BASE = " $OPENSSL_BASE
    echo "FIPS_BASE = " $FIPS_BASE
    echo "SDKVERSION = " $SDKVERSION
    echo ""

}


# CROSS_SDK is the SDK version being used - adjust as appropriate
# for 4.3 or 5.0 (default)
for i in 9.0 8.1 7.1 5.1 5.0 4.3 do
do
  if [ -d "$CROSS_DEVELOPER/Platforms/iPhone$CROSS_TYPE.platform//Developer/SDKs/iPhone$CROSS_TYPE"$i".sdk" ]; then
    SDKVER=$i
    break
  fi
done

echo "fred, SDKVER = " $SDKVER
export SDKVERSION=$SDKVER
echo "fred, SDKVERSION = " $SDKVERSION
#export SDKVERSION="9.0"

echo "fred, SDKVERSION = " $SDKVERSION
    printEnv
        # Switch to new (5.5 dev tools) for device build 
        sudo xcode-select --switch /Applications/Xcode.app

        cd $T2_BUILD_DIR
        mkdir lib$T2_BUILD_PLATFORM

        . ./setenv-reset.sh

export CROSS_TYPE=OS
    

        ARCH="armv7"
        CURRENTPATH=`pwd`
        PLATFORM="iPhoneOS"
        DEVELOPER=`xcode-select -print-path`


        set -e

        mkdir -p "${CURRENTPATH}/bin"

        tar zxf $OPENSSL_BASE.tar.gz -C "${CURRENTPATH}"
        cd "${CURRENTPATH}/$OPENSSL_BASE"

        export CROSS_TOP="${DEVELOPER}/Platforms/${PLATFORM}.platform/Developer"
        export CROSS_SDK="${PLATFORM}${SDKVERSION}.sdk"
        export BUILD_TOOLS="${DEVELOPER}"

        echo "Building $OPENSSL_BASE for ${PLATFORM} ${SDKVERSION} ${ARCH}"
        echo "Please stand by..."

        export CC="${BUILD_TOOLS}/usr/bin/gcc -arch ${ARCH}"
        mkdir -p "${CURRENTPATH}/bin/${PLATFORM}${SDKVERSION}-${ARCH}.sdk"

        set +e

    printEnv


        # ./Configure builds the makefile (Based on makefile.org and input parameters) that will be used to build the FIPS library
        ./Configure iphoneos-cross --openssldir="${CURRENTPATH}/bin/${PLATFORM}${SDKVERSION}-${ARCH}.sdk" fips --with-fipsdir=$INSTALL_DIR


        if [ $? != 0 ];
        then 
            echo "Problem while configure - Please check ${LOG}"
            exit 1
        fi

        # add -isysroot to CC=
       # sed -ie "s!^CFLAG=!CFLAG=-isysroot ${CROSS_TOP}/SDKs/${CROSS_SDK} -miphoneos-version-min=7.0 !" "Makefile"
       sed -ie "s!^CFLAG=!CFLAG=-miphoneos-version-min=7.0 !" "Makefile"


       #there is a problem with the latest version of perl (5.18 not recognizing the POD document format.
        # we're4 not using the documents, only the library, so don't try to build them
        sed -ie 's/install: all install_docs install_sw/install: all install_sw/' "Makefile"
       # sed -ie 's/install: all install_docs install_sw/install: all/' "Makefile"        

       #Dito for the apps and tests - sice we're cross compiling we don't need them
        #sed -ie 's/build_all: build_libs build_apps build_tests build_tools/build_all: build_libs/' "Makefile"



        #make
        make build_libs

        if [ $? != 0 ];
        then 
            echo "Problem while make - Please check ${LOG}"
            exit 1
        fi
          
    set -e
 #   make install 
  #  make clean 
pwd
    # copy the lib to the intermediate lib directory
    cp libcrypto.a ../libarmv7

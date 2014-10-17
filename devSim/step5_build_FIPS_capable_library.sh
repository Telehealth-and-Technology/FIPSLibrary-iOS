# #---------------------------------------------------------
# # build FIPS Capable library
# #---------------------------------------------------------
        # Switch to new (5.5 dev tools) for device build 
        sudo xcode-select --switch /Applications/Xcode.app

        cd devSim
        mkdir libi386

        . ./setenv-reset.sh

        ARCH="i386"
        CURRENTPATH=`pwd`
        PLATFORM="iPhoneSimulator"
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

        ./Configure iphoneos-cross --openssldir="${CURRENTPATH}/bin/${PLATFORM}${SDKVERSION}-${ARCH}.sdk" fips --with-fipsdir=$INSTALL_DIR


        if [ $? != 0 ];
        then 
            echo "Problem while configure - Please check ${LOG}"
            exit 1
        fi

        # add -isysroot to CC=
        sed -ie "s!^CFLAG=!CFLAG=-isysroot ${CROSS_TOP}/SDKs/${CROSS_SDK} -miphoneos-version-min=7.0 !" "Makefile"

        make

        if [ $? != 0 ];
        then 
            echo "Problem while make - Please check ${LOG}"
            exit 1
        fi
          
    set -e
    make install 
  #  make clean 
pwd
 # cp ${CURRENTPATH}/bin/${PLATFORM}${SDKVERSION}-${ARCH}.sdk/lib/libcrypto.a $CURRENTPATH
    # copy the lib to the intermediate lib directory
    cp libcrypto.a ../libi386

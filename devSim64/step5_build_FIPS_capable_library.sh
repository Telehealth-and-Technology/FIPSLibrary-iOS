echo ""
echo "#---------------------------------------------------------"
echo "# Step 5 build FIPS Capable library"
echo "#---------------------------------------------------------"
        # Switch to new (5.5 dev tools) for this build 
        sudo xcode-select --switch /Applications/Xcode.app

        cd $T2_BUILD_DIR
        mkdir lib$T2_BUILD_PLATFORM

        . ./setenv-reset.sh

        ARCH="x86_64"
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

       ./Configure darwin64-x86_64-cc --openssldir="${CURRENTPATH}/bin/${PLATFORM}${SDKVERSION}-${ARCH}.sdk" fips --with-fipsdir=$INSTALL_DIR

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

    # copy the lib to the intermediate lib directory
    cp libcrypto.a ../lib$T2_BUILD_PLATFORM

echo ""
echo "#---------------------------------------------------------"
echo "# Step 5 build FIPS Capable library"
echo "#---------------------------------------------------------"
 
    cd $T2_BUILD_DIR
    mkdir lib$T2_BUILD_PLATFORM

    # unpack fresh files
    tar xzf $OPENSSL_BASE.tar.gz 

    # move to ssl' dir
    cd $OPENSSL_BASE/

    . ../setenv-reset.sh
    . ../setenv-ios-arm64.sh

    OLD_LANG=$LANG
    unset LANG

        sed -i "" 's|\"iphoneos-cross\"\,\"llvm-gcc\:-O3|\"iphoneos-cross\"\,\"clang\:-Os|g' Configure
        sed -i "" 's/CC= cc/CC= clang/g' Makefile.org
        sed -i "" 's/CFLAG= -O/CFLAG= -Os/g' Makefile.org
        sed -i "" 's/MAKEDEPPROG=makedepend/MAKEDEPPROG=$(CC) -M/g' Makefile.org
    export LANG=$OLD_LANG

    ./config fips -no-shared -no-comp -no-dso -no-hw -no-engines -no-sslv2 -no-sslv3 --with-fipsdir=$INSTALL_DIR
    if [ $? != 0 ];
    then 
        echo "Problem while configure - Please check ${LOG}"
        exit 1
    fi

        # add -isysroot to CC=
        #sed -ie "s!^CFLAG=!CFLAG=-isysroot ${CROSS_TOP}/SDKs/${CROSS_SDK} -miphoneos-version-min=7.0 !" "Makefile"

    make build_libs
    if [ $? != 0 ];
    then 
        echo "Problem while make - Please check ${LOG}"
        exit 1
    fi

    # copy the lib to the intermediate lib directory
    cp libcrypto.a ../lib$T2_BUILD_PLATFORM


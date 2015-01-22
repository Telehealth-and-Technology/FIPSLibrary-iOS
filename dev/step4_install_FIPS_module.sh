#---------------------------------------------------------
# install FIPS Object Module
#
# /usr/local/ssl/Release-iphoneos/
#---------------------------------------------------------
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
	echo ""

}

printEnv

# move to Source dir
cd $T2_BUILD_DIR

# move to fips' dir
cd $FIPS_BASE

# install - may require root...
make install

# delete artifacts
rm -Rf $FIPS_BASE/

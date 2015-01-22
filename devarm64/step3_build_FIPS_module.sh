echo ""
echo "echo "#---------------------------------------------------------""
echo "echo "# Step 3 build FIPS Object Module""
echo "echo "#---------------------------------------------------------""


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
	echo "CONFIG_OPTIONS = " $CONFIG_OPTIONS
	echo ""
}

cd $T2_BUILD_DIR

# get a fresh copy of fips module source 
tar xzf $FIPS_BASE.tar.gz

cd $FIPS_BASE

OLD_LANG=$LANG
unset LANG

sed -i "" 's|\"iphoneos-cross\"\,\"llvm-gcc\:-O3|\"iphoneos-cross\"\,\"clang\:-Os|g' Configure

export LANG=$OLD_LANG
export CC=clang

#make clean
#rm -f *.dylib

. ../setenv-reset.sh
. ../setenv-ios-arm64.sh


# Due to a problem with the newer os-x tools the simulator (not the device) build fails the fips signature check
# For now we'll disable this check (for the simulator only)
# Note that this breaks fips compiliance for the simulator but we're still fips compliant with the actual device build
# sed -ie 's/FIPS_check_incore_fingerprint(void)/FIPS_check_incore_fingerprint(void) {return 1;}  int dummy(void)/' "./fips/fips.c"


printEnv

./config --openssldir=$INSTALL_DIR

#make clean
make


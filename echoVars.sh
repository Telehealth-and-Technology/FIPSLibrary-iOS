# Copyright � 2009-2015 United States Government as represented by
# the Chief Information Officer of the National Center for Telehealth
# and Technology. All Rights Reserved.

# Copyright � 2009-2015 Contributors. All Rights Reserved.

# THIS OPEN SOURCE AGREEMENT ("AGREEMENT") DEFINES THE RIGHTS OF USE,
# REPRODUCTION, DISTRIBUTION, MODIFICATION AND REDISTRIBUTION OF CERTAIN
# COMPUTER SOFTWARE ORIGINALLY RELEASED BY THE UNITED STATES GOVERNMENT
# AS REPRESENTED BY THE GOVERNMENT AGENCY LISTED BELOW ("GOVERNMENT AGENCY").
# THE UNITED STATES GOVERNMENT, AS REPRESENTED BY GOVERNMENT AGENCY, IS AN
# INTENDED THIRD-PARTY BENEFICIARY OF ALL SUBSEQUENT DISTRIBUTIONS OR
# REDISTRIBUTIONS OF THE SUBJECT SOFTWARE. ANYONE WHO USES, REPRODUCES,
# DISTRIBUTES, MODIFIES OR REDISTRIBUTES THE SUBJECT SOFTWARE, AS DEFINED
# HEREIN, OR ANY PART THEREOF, IS, BY THAT ACTION, ACCEPTING IN FULL THE
# RESPONSIBILITIES AND OBLIGATIONS CONTAINED IN THIS AGREEMENT.

# Government Agency: The National Center for Telehealth and Technology
# Government Agency Original Software Designation: T2Crypto
# Government Agency Original Software Title: T2Crypto
# User Registration Requested. Please send email
# with your contact information to: robert.a.kayl.civ@mail.mil
# Government Agency Point of Contact for Original Software: robert.a.kayl.civ@mail.mil


EchoVars()
{
    echo ""
    echo "-----------------------------------------------"
    echo "FIPS build environment variables  "
    echo "$1"
    echo "-----------------------------------------------"    

if [ ! -z "$CROSS_TOP" ];       then echo "CROSS_TOP =      $CROSS_TOP"; fi
if [ ! -z "$SDKVERSION" ];      then echo "SDKVERSION =     $SDKVERSION"; fi
if [ ! -z "$CROSS_SDK" ];       then echo "CROSS_SDK =      $CROSS_SDK"; fi
if [ ! -z "$HOSTCC" ];          then echo "HOSTCC =         $HOSTCC"; fi
if [ ! -z "$HOSTCFLAGS" ];      then echo "HOSTCFLAGS =     $HOSTCFLAGS"; fi
if [ ! -z "$CROSS_COMPILE" ];   then echo "CROSS_COMPILE =  $CROSS_COMPILE"; fi
if [ ! -z "$FIPS_SIG" ];        then echo "FIPS_SIG =       $FIPS_SIG"; fi
if [ ! -z "$IOS_TARGET" ];      then echo "IOS_TARGET =     $IOS_TARGET"; fi
if [ ! -z "$IOS_INSTALLDIR" ];  then echo "IOS_INSTALLDIR = $IOS_INSTALLDIR"; fi
if [ ! -z "$MACHINE" ];         then echo "MACHINE =        $MACHINE"; fi
if [ ! -z "$SYSTEM" ];          then echo "SYSTEM =         $SYSTEM"; fi
if [ ! -z "$BUILD" ];           then echo "BUILD =          $BUILD"; fi
if [ ! -z "$CONFIG_OPTIONS" ];  then echo "CONFIG_OPTIONS = $CONFIG_OPTIONS"; fi
if [ ! -z "$CC" ];              then echo "CC =             $CC"; fi
    echo ""   
if [ ! -z "$CROSS_ARCH" ];      then echo "CROSS_ARCH =     $CROSS_ARCH"; fi
if [ ! -z "$CROSS_TYPE" ];      then echo "CROSS_TYPE =     $CROSS_TYPE"; fi
if [ ! -z "$CROSS_DEVELOPER" ]; then echo "CROSS_DEVELOPER =$CROSS_DEVELOPER"; fi
if [ ! -z "$CROSS_CHAIN" ];     then echo "CROSS_CHAIN =    $CROSS_CHAIN"; fi
if [ ! -z "$CROSS_SYSROOT" ];   then echo "CROSS_SYSROOT =  $CROSS_SYSROOT"; fi
if [ ! -z "$RELEASE" ];         then echo "RELEASE =        $RELEASE"; fi
if [ ! -z "$KERNEL_BITS" ];     then echo "KERNEL_BITS =    $KERNEL_BITS"; fi
if [ ! -z "$INSTALL_DIR" ];     then echo "INSTALL_DIR =    $INSTALL_DIR"; fi
if [ ! -z "$OPENSSL_BASE" ];    then echo "OPENSSL_BASE =   $OPENSSL_BASE"; fi
if [ ! -z "$FIPS_BASE" ];       then echo "FIPS_BASE =      $FIPS_BASE"; fi
if [ ! -z "$PATH" ];            then echo "PATH =           $PATH"; fi
    # echo "CROSS_TOP = " $CROSS_TOP
    # echo "SDKVERSION = " $SDKVERSION
    # echo "CROSS_SDK = " $CROSS_SDK
    # echo "HOSTCC = " $HOSTCC 
    # echo "HOSTCFLAGS = " $HOSTCFLAGS      
    # echo "CROSS_COMPILE = " $CROSS_COMPILE
    # echo "FIPS_SIG = " $FIPS_SIG
    # echo "IOS_TARGET = " $IOS_TARGET
    # echo "IOS_INSTALLDIR = " $IOS_INSTALLDIR           
    # echo "MACHINE = " $MACHINE
    # echo "SYSTEM = " $SYSTEM
    # echo "BUILD = " $BUILD
    # echo "CONFIG_OPTIONS = " $CONFIG_OPTIONS  
    # echo "BUILD_TOOLS = " $BUILD_TOOLS  
    # echo "CONFIG_OPTIONS = " $CC  
    # echo "PATH = " $PATH  
    # echo ""    
    # echo "CROSS_ARCH = " $CROSS_ARCH
    # echo "CROSS_TYPE = " $CROSS_TYPE
    # echo "CROSS_DEVELOPER = " $CROSS_DEVELOPER
    # echo "CROSS_CHAIN = " $CROSS_CHAIN
    # echo "CROSS_SDK = " $CROSS_SDK
    # echo "CROSS_SYSROOT = " $CROSS_SYSROOT
    # echo "RELEASE = " $RELEASE
    # echo "KERNEL_BITS = " $KERNEL_BITS
    # echo "INSTALL_DIR = " $INSTALL_DIR
    # echo "OPENSSL_BASE = " $OPENSSL_BASE
    # echo "FIPS_BASE = " $FIPS_BASE
    echo "-----------------------------------------------"        
    echo ""

}


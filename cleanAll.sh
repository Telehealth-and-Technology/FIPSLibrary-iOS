

    read -p "press y to clean directory structure  " yn
    case $yn in
      [Yy]* ) 

		# This sets up environment vars to point to which openssl/fips we cant to use
		. ./setEnvOpensslFiles.sh

		  echo ""
		  echo "*************************************************"
		  echo "Cleaning directory structure"
		  echo "*************************************************"

		PROJECTPATH=`pwd`

		rm -Rf devSim/bin/
		rm -Rf devSim/libi386/

		rm -Rf devSim64/bin/
		rm -Rf devSim64/libx86_64/

		rm -Rf devarm64/bin/
		rm -Rf devarm64/libarm64/

		rm -Rf dev/bin/
		rm -Rf dev/libarmv7/

# 
		rm -Rf dev/$OPENSSL_BASE/
		rm -Rf dev/$FIPS_BASE/

		rm -Rf devSim/$FIPS_BASE/
		rm -Rf devSim/$OPENSSL_BASE/

		rm -Rf devSim64/$FIPS_BASE/
		rm -Rf devSim64/$OPENSSL_BASE/

		rm -Rf devarm64/$FIPS_BASE/
		rm -Rf devarm64/$OPENSSL_BASE/

# 
		rm -Rf devarm64/*.gz
		rm -Rf devSim64/*.gz
		rm -Rf devSim/*.gz
		rm -Rf dev/*.gz
		rm -Rf sqlcipher
		rm -Rf release
		rm libcrypto.a

		LIB_SIM_CRYPTO=${PROJECTPATH}/devSim/libcrypto.a
		LIB_SIM_SSL=${PROJECTPATH}/devSim/src/$OPENSSL_BASE/libssl.a 
		rm -Rf $LIB_SIM_CRYPTO
		rm -Rf $LIB_SIM_SSL

		LIB_SIM_CRYPTO=${PROJECTPATH}/devSim64/libcrypto.a
		LIB_SIM_SSL=${PROJECTPATH}/devSim64/src/$OPENSSL_BASE/libssl.a 
		rm -Rf $LIB_SIM_CRYPTO
		rm -Rf $LIB_SIM_SSL

    esac





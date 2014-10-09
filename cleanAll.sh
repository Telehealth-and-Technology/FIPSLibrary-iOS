

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
		rm -Rf dev/libarmv7/

		rm -Rf dev/$OPENSSL_BASE/
		rm -Rf dev/$FIPS_BASE/
		rm -Rf devSim/$FIPS_BASE/
		rm -Rf devSim/$OPENSSL_BASE/

		rm -Rf devSim/*.gz
		rm -Rf dev/*.gz
		rm -Rf sqlcipher

		LIB_SIM_CRYPTO=${PROJECTPATH}/devSim/libcrypto.a
		LIB_SIM_SSL=${PROJECTPATH}/devSim/src/$OPENSSL_BASE/libssl.a 

		rm -Rf $LIB_SIM_CRYPTO
		rm -Rf $LIB_SIM_SSL

    esac





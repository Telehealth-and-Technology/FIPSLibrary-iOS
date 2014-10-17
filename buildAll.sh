PROJECTPATH=`pwd`
abortBuild=0

# Checks for the existance of opssl/fips files and offers to copy them from local resources 
# sets abortBuild = 1 if there are missing files and user chooses to abort build
checkforFipsFiles()
{
	if [ ! -n "$sslFiles_dev" ] || [ ! -n "$sslFiles_sim" ] || [ ! -n "$fipsFiles_dev" ] || [ ! -n "$fipsFiles_sim" ]; then 

	  	echo ""
	  	echo "!!!! One or more of the fips download files are missing !!!!!"
	  	echo "" 
		echo "sslFiles_dev = $sslFiles_dev"
		echo "sslFiles_sim = $sslFiles_sim"
		echo "fipsFiles_dev = $fipsFiles_dev"
		echo "fipsFiles_sim = $fipsFiles_sim"		
		echo ""

	  	echo "You have two options:"

	  	echo "Option y - Copy local (unofficial) openssl downlad files form this distribution"
	  	echo "Option n - Stop build so you can download the official files"
	 	echo ""

	   	read -p "press y or n : " yn
	    case $yn in
	      [Yy]* ) 
			echo "Copying local files"
			cp localFipsSslFiles/*.gz ./dev
			cp localFipsSslFiles/*.gz ./devSim

	      ;;
	      [Yn]* ) 
	        echo "you chose no"
	        abortBuild=1
	        ;;
	      * ) echo "please choose";;
	    esac

	fi
}

# Checks for the existance of sqlcipher files and offers to copy them from local resources 
# sets abortBuild = 1 if there are missing files and user chooses to abort build
checkForSqlcipherFiels()
{
	if [ ! -d "$sqlcipherFiles" ]; then 


	  	echo ""
	  	echo "!!!! One or more of the sqlCipher download files are missing !!!!!"
	  	echo "" 
	   	echo "sqlcipherFiles = $sqlcipherFiles"
		echo ""
	  	echo "You have two options:"
		echo "Option y - Copy local (unofficial) sqlCipher downlad files form this distribution"
	  	echo "Option n - Stop build so you can download the official files"
	  	echo ""

	   	read -p "press y or n : " yn
	    case $yn in
	      [Yy]* ) 
			echo "Copying local files"
			cp -r localFipsSslFiles/sqlcipher ./
			cd sqlCipher
				# Make sure cqlcipher files are RW
			chmod -R 777 ./
			cd ..
			

	      ;;
	      [Yn]* ) 
	        echo "you chose no"
	        abortBuild=1
	        ;;
	      * ) echo "please choose";;
	    esac

	fi
}


# This sets up environment vars to point to which openssl/fips we want to use
. ./setEnvOpensslFiles.sh
echo "using $OPENSSL_BASE.tar.gz"
echo "using $FIPS_BASE.tar.gz"


fipsSslFiles_dev="1"
sqlCipherFiles_dev="1"
echo ""


# fips/openssl files
sslFiles_dev="dev/$OPENSSL_BASE.tar.gz"
fipsFiles_dev="dev/$FIPS_BASE.tar.gz"

sslFiles_sim="devSim/$OPENSSL_BASE.tar.gz"
fipsFiles_sim="devSim/$FIPS_BASE.tar.gz"

# sqlcipher files
sqlcipherFiles="sqlcipher"

# Set variables to tell if files are missing or not 
if [ ! -f "$sslFiles_dev" ]; then
  sslFiles_dev=""
fi

if [ ! -f "$sslFiles_sim" ]; then
  sslFiles_sim=""
fi


if [ ! -f "$fipsFiles_dev" ]; then
  fipsFiles_dev=""
fi

if [ ! -f "$fipsFiles_sim" ]; then
  fipsFiles_sim=""
fi

if [ ! -f "$sqlcipherFiles" ]; then
  fsqlcipherFiles=""
fi



# Checkfor existance of necessary files
checkforFipsFiles
checkForSqlcipherFiels

if [ "$abortBuild" == 1 ]; then
	echo "******** Aborting build ************"

else

  	echo ""
  	echo "--- All files present and accounted for, proceeding with build ---"
 	echo "" 
	. ./buildAllDevice.sh
	. ./buildAllSim.sh

	echo ""
	echo "-----------------------------------------"
	echo " Now building and installing final fat lib files"
	echo "-----------------------------------------"

	cd $PROJECTPATH

	# Set _LIB_SIM_CRYPTO and _LIB_DEVICE_CRYPTO based on whether or not libcrypto.a exists in directories
	[[ -s ${PROJECTPATH}/devSim/libi386/libcrypto.a ]] && _LIB_SIM_CRYPTO=${PROJECTPATH}/devSim/libi386/libcrypto.a  || _LIB_SIM_CRYPTO=""
	[[ -s ${PROJECTPATH}/dev/libarmv7/libcrypto.a ]] && _LIB_DEVICE_CRYPTO=${PROJECTPATH}/dev/libarmv7/libcrypto.a || _LIB_DEVICE_CRYPTO=""

	#todo: Add processing for libssl - although not that important since we are not using it, only libcrypto

	echo "_LIB_SIM_CRYPTO = $_LIB_SIM_CRYPTO"
	echo "_LIB_DEVICE_CRYPTO = $_LIB_DEVICE_CRYPTO"

	# Create the fat file
	# *** Note: we're using the tool lipo here. The problem is that lipo changed locations from xcode 4x to 5x and is dependent on if you have
	# mavricks or not. To side step this issue we store a known good copy of the tool (iphoneoslipo) in CMS to use here

	if test ! -z "$_LIB_SIM_CRYPTO" || test ! -z "$_LIB_DEVICE_CRYPTO";  then
	    echo "command line = ./iphoneoslipo -create $_LIB_SIM_CRYPTO  $_LIB_DEVICE_CRYPTO -output ./libcrypto.a" 
	    ./iphoneoslipo -create $_LIB_SIM_CRYPTO  $_LIB_DEVICE_CRYPTO -output ./libcrypto.a
	    cp ./libcrypto.a $INSTALL_DIR
	    echo ""
	    echo "Installed libcrypto.a (fat files) at $INSTALL_DIR"
	else
	    echo "No libaraies to create fat file from!"

	fi

	# Make sure cqlcipher files are RW
	chmod -R 777 ./sqlcipher 

fi











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
				echo "sslFiles_sim64 = $sslFiles_sim64"
		echo "fipsFiles_dev = $fipsFiles_dev"
		echo "fipsFiles_sim = $fipsFiles_sim"		
				echo "fipsFiles_sim64 = $fipsFiles_sim64"	
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
			cp localFipsSslFiles/*.gz ./devSim64
			cp localFipsSslFiles/*.gz ./devarm64
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
echo "Using IOS SDK $SDKVERSION !!!!"
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

sslFiles_sim64="devSim64/$OPENSSL_BASE.tar.gz"
fipsFiles_sim64="devSim64/$FIPS_BASE.tar.gz"

# sqlcipher files
sqlcipherFiles="sqlcipher"

# Set variables to tell if files are missing or not 
if [ ! -f "$sslFiles_dev" ]; then
  sslFiles_dev=""
fi

if [ ! -f "$sslFiles_sim" ]; then
  sslFiles_sim=""
fi


if [ ! -f "$sslFiles_sim64" ]; then
  sslFiles_sim64=""
fi


if [ ! -f "$fipsFiles_dev" ]; then
  fipsFiles_dev=""
fi

if [ ! -f "$fipsFiles_sim" ]; then
  fipsFiles_sim=""
fi


if [ ! -f "$fipsFiles_sim" ]; then
  fipsFiles_sim64=""
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



 	# Note: when adding new platforms, don't forget to set up the command variables T2_BUILD_DIR, and T2_BUILD_PLATFORM
 	# T2_BUILD_DIR tells the sub-shell what directory to use
 	# T2_BUILD_PLATFORM tells the sub-shell what platform (and what to name the folder to put the architecture specific .a file)
 	#     Used in Aggregate link files section below

 	# 	---- Build for 32 bit device ------------
 	echo " Building for 32 bit device"
 	export T2_BUILD_DIR="dev"
	export T2_BUILD_PLATFORM="armv7"
	. ./buildAllDevice.sh
	
 	# ---- Build for 32 bit simulator ------------
 	echo " Building for IOS 32 bit Simulator"
	export T2_BUILD_DIR="devSim"
	export T2_BUILD_PLATFORM="i386"
	. ./buildAllSim.sh

 	# ---- Build for 64 bit simulator ------------
 	echo " Building for IOS 64 bit Simulator"
	export T2_BUILD_DIR="devSim64"
	export T2_BUILD_PLATFORM="x86_64"
	. ./buildAllSim64.sh

	# ---- Build for 64 bit device ------------
 	echo " Building for IOS 64 bit device"
	export T2_BUILD_DIR="devarm64"
	export T2_BUILD_PLATFORM="arm64"
	. ./buildAllarm64.sh


	echo ""
	echo "-----------------------------------------"
	echo " Now building and installing final fat lib files"
	echo "-----------------------------------------"

	cd $PROJECTPATH


	#  *** Aggregate link files ***
	# Check for the existence of linker files, if any exist, create a fat file with the ones that exist in it
	# NOOTE: when new platforms are added to this file the following lines must be appended

	FILES=""
	TEST_PATH=${PROJECTPATH}/devarm64/libarm64/libcrypto.a
	[ -f $TEST_PATH ] && FILES=$FILES" $TEST_PATH"

	TEST_PATH=${PROJECTPATH}/devSim64/libX86_64/libcrypto.a
	[ -f $TEST_PATH ] && FILES=$FILES" $TEST_PATH"

	TEST_PATH=${PROJECTPATH}/devSim/libi386/libcrypto.a
	[ -f $TEST_PATH ] && FILES=$FILES" $TEST_PATH"

	TEST_PATH=${PROJECTPATH}/dev/libarmv7/libcrypto.a
	[ -f $TEST_PATH ] && FILES=$FILES" $TEST_PATH"


	# if any existed, make a fat file and copy it to the install dire
	if [ "$FILES" != "" ]; then

		COMMAND="./iphoneoslipo -create $FILES -output ./libcrypto.a"
		echo "running COMMAND = " $COMMAND

	    $COMMAND
	    cp ./libcrypto.a $INSTALL_DIR

	else
		echo "*****************  No files to add to fat link file!!"
	fi



	# Make sure cqlcipher files are RW
	chmod -R 777 ./sqlcipher 

fi











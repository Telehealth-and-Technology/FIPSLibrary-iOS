ReleaseName="testReleaseName"
  read -p "Enter your release name (Ex: V1.1_06_13-2014): " ReleaseName

# This sets up environment vars to point to which openssl/fips we want to use
. ./setEnvOpensslFiles.sh
echo "using $OPENSSL_BASE.tar.gz"
echo "using $FIPS_BASE.tar.gz"
echo "using $INSTALL_DIR"

gccVersion="4.2.1"

fipsDir=$INSTALL_DIR
premainC="/usr/local/ssl/fips-2.0/lib/fips_premain.c"
premainSha="/usr/local/ssl/fips-2.0/lib/fips_premain.c.sha1"
canisterO="/usr/local/ssl/fips-2.0/lib/fipscanister.o"
fanisterSha="/usr/local/ssl/fips-2.0/lib/fipscanister.o.sha1"

sslSrc="./libcrypto.a"
sslDst="release/$ReleaseName/object/openssl"

mkdir -p release
mkdir -p release/$ReleaseName
mkdir -p release/$ReleaseName/source
mkdir -p release/$ReleaseName/source/dev
mkdir -p release/$ReleaseName/source/devSim
mkdir -p release/$ReleaseName/object
mkdir -p release/$ReleaseName/object/usr/local/ssl
mkdir -p release/$ReleaseName/doc
mkdir -p $sslDst

# # copy object files
cp -r $fipsDir* release/$ReleaseName/object/usr/local/ssl
cp -f $sslSrc $sslDst 


# #copy doc files

cp HowToUseLibrary.txt release/$ReleaseName
cp *.txt release/$ReleaseName/doc
cp -r doc release/$ReleaseName

#copy source files
cp -r dev/SupplementalFiles* release/$ReleaseName/source/dev
cp -r devSim/SupplementalFiles* release/$ReleaseName/source/devSim

# copy test files
cp -r test release/$ReleaseName/test

# copy install fips script
cp ./SupplementalFiles/installFipsRelease.sh release/$ReleaseName
cp ./setEnvOpenSslFiles.sh release/$ReleaseName

# copy canned sqlcipher directory
cp -r ./sqlcipher release/$ReleaseName


# #Remove lib build instructions so they dont confuse end app developers
rm -f release/$ReleaseName/doc/BuildInstructions*.txt

# #--------------------------------------------------
# #build the FIPS140-2ObjectModuleRecord.txt file
# #--------------------------------------------------

fipsCanisterSha="$INSTALL_DIR/lib/fipscanister.o.sha1"
docDst="release/$ReleaseName/doc"

# get filename of the fips object module source tar file
nameAndPath=$(ls dev/openssl-fips*.gz)
nameOnly=$(basename $nameAndPath)

# get sha1 of the fips object modu;e
fipsSha1=$(cat $fipsCanisterSha)


objectModelFileRecordName="$docDst/FIPS140-2ObjectModuleRecord.txt"

# We only report from the device build (.dev)
fipsFileBaseName=$(find . -maxdepth 2 -type d -and -not -name '*.gz' -and -name 'openssl-fips*' -and -path "./dev/*" | cut -c 7-99)


echo "1.	The $fipsFileBaseName.tar.gz file distribution file which was used as the basis for the production of the FIPS 
		object module was obtained from  the  FIPS compatible OpenSSL library from physical media (CD) 
		obtained directly from the OpenSSL foundation." > $objectModelFileRecordName
echo "2.	The host platform on which the fipscanister.o, fipscanister.o.sha1,fips_premain.c, 
		and fips_premain.c.sha1 files were generated is OX-X. The compiler used was gcc version $gccVersion." >> $objectModelFileRecordName
echo "3.	The fipscanister.o module was generated with exactly the three commands:
			./config
			make                      
			make install
		No other build-time options were specified." >> $objectModelFileRecordName
echo "4.	The HMAC SHA-1 digest of the produced fipscanister.o is: 
		$fipsSha1" >> $objectModelFileRecordName
echo "5.	The contents of the distribution file used to create 
		fipscanister.o was not manually modified in any way at any time during the build process." >> $objectModelFileRecordName

echo ""
echo "Release was created at: release/$ReleaseName"
echo ""


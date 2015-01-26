# This script will install the FIPS files from the release directory of this build to the protected space in OS-x 
# This sets up environment vars to point to which openssl/fips we want to use
. ./setEnvOpensslFiles.sh
echo ""
echo ""
echo ""
echo "Attempting to install FIPS release"
echo ""






if [ ! -d "/usr" ]; then
  echo ""
  echo ""
  echo ""
  echo "Error - Can't reach /usr file - check permissions - make sure to invoke with sudo (sudo ./installFipsRelease.sh)"
  echo ""
  echo ""
  echo ""
  exit 1
fi

if [ ! -d "/usr/local" ]; then
    mkdir usr/local
    if [ $? != 0 ];
    then 
        echo "ERROR creating usr/local - check permissions - make sure to invoke with sudo (sudo ./installFipsRelease.sh)"
        exit 1
    fi
fi

if [ ! -d "/usr/local/bin" ]; then
    echo "creating /usr/local/bin"
    mkdir /usr/local/bin
    if [ $? != 0 ];
    then 
        echo "ERROR creating /usr/local/bin"
        exit 1
    fi
fi

echo ""
echo "copying incore_macho tool to /usr/local/bin"
cp incore_macho /usr/local/bin
if [ $? != 0 ];
then 
    echo ""
    echo "ERROR copying files - Check permissions - make sure to invoke with sudo (sudo ./installFipsRelease.sh)"
    exit 1
else
    echo "File copy success!"
    chmod 555 /usr/local/bin/incore_macho
    echo ""
    echo ""
    echo ""
fi



if [ ! -d "/usr/local/ssl" ]; then
    echo "creating /usr/local/ssl"
    mkdir /usr/local/ssl
    if [ $? != 0 ];
    then 
        echo "ERROR creating /usr/local/ssl"
        exit 1
    fi
fi


echo ""
echo "copying FIPS files from ./object$INSTALL_DIR to /usr/local/ssl"
cp -r ./object$INSTALL_DIR /usr/local/ssl
if [ $? != 0 ];
then 
    echo ""
    echo "ERROR copying files - Check permissions (make sure to invoke with sudo (sudo ./installFipsRelease.sh)"
    exit 1
else
    echo "File copy success!"
    echo ""
    echo ""
    echo ""
fi


# This script will install the FIPS files from the release directory of this build to the protected space in OS-x 
# This sets up environment vars to point to which openssl/fips we want to use
. ./setEnvOpensslFiles.sh
cp -r ./object$INSTALL_DIR /usr/local/ssl
# Change these to the openssl and FIPS files that you want to compile with
export OPENSSL_BASE=openssl-1.0.1f
export FIPS_BASE=openssl-fips-2.0.2
export INSTALL_DIR=/usr/local/ssl/Release-iphoneos

# Note: we're specifying simulator here but it doesn't matter because we're only using this to determine which sdk is present
CROSS_TYPE=Simulator
CROSS_DEVELOPER="/Applications//Xcode.app/Contents/Developer"

# dynamically determine which sdk to use
# CROSS_SDK is the SDK version being used - adjust as appropriate
# 8.1 (default)
for i in 8.1 7.1 5.1 5.0 4.3
	do

	  if [ -d "$CROSS_DEVELOPER/Platforms/iPhone$CROSS_TYPE.platform//Developer/SDKs/iPhone$CROSS_TYPE"$i".sdk" ]; then
	    SDKVER=$i
	    export SDKVERSION=$i
	    break

	  fi
	done

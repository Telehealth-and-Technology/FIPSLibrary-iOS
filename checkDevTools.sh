if [ ! -d "/XCode4.6/Xcode.app" ]; then
  echo ""
  echo ""
  echo ""
  echo "*** Development tools error!"
  echo "You must have Xcode V4.6 installed at /XCode4.6/Xcode.app to continue"
  echo ""
  echo "This is necessary only for the 32 bit dev build"
  echo ""
  exit 1
fi

if [ ! -d "/Applications/Xcode.app" ]; then
  echo ""
  echo ""
  echo ""
  echo "*** Development tools error!"
  echo "You must have Xcode installed at /Applications/Xcode.app to continue"
  echo ""
  echo ""
  echo ""
  exit 1
fi



#---------------------------------------------------------
# remove quarantine bit and ensure the execute bit is set
#---------------------------------------------------------

# move to Source dir
cd $T2_BUILD_DIR

xattr -r -d "com.apple.quarantine" *.tar
xattr -r -d "com.apple.quarantine" *.sh
chmod +x *.sh
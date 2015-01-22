echo ""
echo "#---------------------------------------------------------"
echo "# Step 1 Remove quarantine bit and ensure the execute bit is set"
echo "#---------------------------------------------------------"

# move to Source dir
cd $T2_BUILD_DIR

xattr -r -d "com.apple.quarantine" *.tar
xattr -r -d "com.apple.quarantine" *.sh
chmod +x *.sh
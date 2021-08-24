# Build documentation

# More info here: https://developer.apple.com/documentation/Xcode/distributing-documentation-to-external-developers

xcodebuild docbuild -scheme CMarkGFM -derivedDataPath DerivedData

export DOCC_ARCHIVE="$(find DerivedData -type d -name '*.doccarchive')"
pushd $DOCC_ARCHIVE/..
zip -Xr CMarkGFM.doccarchive.zip CMarkGFM.doccarchive
popd
mv $DOCC_ARCHIVE/../CMarkGFM.doccarchive.zip .

# Zip gets attached to GitHub release.


# Clean up

rm -rf DerivedData CMarkGFM.doccarchive.zip

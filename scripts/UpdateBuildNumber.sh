#!/bin/sh

#Updates the required plists with the build numbers. 
#Can pass an argument in to set it
#If no argument is passed, it generates one based on current datetime
if (( ${1} )); then
buildNumber=$1
else
buildNumber=$(date +%y%m%d%H%M)
fi
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "<example>/Resources/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "<anotherPlist>/Info.plist"
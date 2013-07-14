#!/bin/bash
# Build script yanked from https://github.com/Eonil/Bullet-PhysicsEngine-BuildScript-iOS
# Thanks, eonil!
set -e

svn checkout http://bullet.googlecode.com/svn/trunk/ bullet-read-only


####

rm -rf Headers
cp -rf bullet-read-only/src Headers
cd Headers
find . -name ".svn" -print0 | xargs -0 -I {} rm -rf "{}"		#	Needs deferring because `find` wants to navigate into deleted directory.
find . -name "*.cpp" -exec rm -rf "{}" \;
find . -name "*.c" -exec rm -rf "{}" \;
find . -name "*.txt" -exec rm -rf "{}" \;
find . -name "Makefile*" -exec rm -rf "{}" \;
find . -name "Doxy*" -exec rm -rf "{}" \;
find . -name "CMake*" -exec rm -rf "{}" \;
find . -name "*.lua" -exec rm -rf "{}" \;
find . -name ".svn"
cd ..



####

rm -rf Binaries
cd bullet-read-only/build
./premake4_osx --ios xcode4
cd xcode4ios


function DeviceRun()
{
	rm -rf obj
	xcodebuild -project "$1".xcodeproj -configuration "$2" -arch "armv7 armv7s" ARCHS="armv7 armv7s" VALID_ARCHS="armv7 armv7s" ONLY_ACTIVE_ARCH=NO -sdk iphoneos PRODUCT_NAME="$1" CONFIGURATION_BUILD_DIR="../../../Binaries/iOS Device/$2" CONFIGURATION="$2"
}
function SimulatorRun()
{
	rm -rf obj
	xcodebuild -project "$1".xcodeproj -configuration "$2" -arch "i386" ARCHS="i386" VALID_ARCHS="i386" ONLY_ACTIVE_ARCH=NO -sdk iphonesimulator PRODUCT_NAME="$1" CONFIGURATION_BUILD_DIR="../../../Binaries/iOS Simulator/$2" CONFIGURATION="$2"
}
function BothRun()
{
	DeviceRun $1 "$2"
	SimulatorRun $1 "$2"
}
function AllRun()
{
	BothRun $1 "Debug Native 32-bit"
	BothRun $1 "Release Native 32-bit"
}

AllRun BulletCollision
AllRun BulletDynamics
AllRun LinearMath

cd ../../../
find ./Binaries -name "*.a" -exec lipo -info {} \;

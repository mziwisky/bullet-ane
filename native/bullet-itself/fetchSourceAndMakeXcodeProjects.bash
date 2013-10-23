#!/bin/bash
# Build script originally yanked from https://github.com/Eonil/Bullet-PhysicsEngine-BuildScript-iOS
# then trimmed way down.  Thanks, eonil!
set -e

svn checkout http://bullet.googlecode.com/svn/trunk/ bullet-read-only

cd bullet-read-only/build
./premake4_osx --ios xcode4

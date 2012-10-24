#!/bin/bash

SRC=`pwd`

VERSION=`grep '^version_number' ${SRC}/launcher_version_number.py | cut -f 2 -d '"'`
ARCHITECTURE=`uname -m | sed s/x86_64/amd64/g | sed s/i686/i386/g`

./package_linux_version.sh

cd rpmbuild

rm -fr BUILD BUILDROOT RPMS SOURCES SRPMS tmp
mkdir  BUILD BUILDROOT RPMS SOURCES SRPMS tmp

rm -f ~/.rpmmacros
echo "%_topdir  "`pwd`     >> ~/.rpmmacros
echo "%_tmppath "`pwd`/tmp >> ~/.rpmmacros


sed s/VERSION/${VERSION}/g SPECS/massive-launcher.spec.template > SPECS/massive-launcher.spec

rm -fr massive-launcher-${VERSION}

mkdir -p massive-launcher-${VERSION}/opt/MassiveLauncher-${VERSION}_${ARCHITECTURE}
rm -f massive-launcher-${VERSION}.tar.gz SOURCES/massive-launcher-${VERSION}.tar.gz 


cp -r ../dist/MassiveLauncher-${VERSION}_${ARCHITECTURE}/* massive-launcher-${VERSION}/opt/MassiveLauncher-${VERSION}_${ARCHITECTURE}

sed -i "s@/opt/MassiveLauncher@/opt/MassiveLauncher-${VERSION}_${ARCHITECTURE}@g" \
    massive-launcher-${VERSION}/opt/MassiveLauncher-${VERSION}_${ARCHITECTURE}/MASSIVE\ Launcher.desktop \
    massive-launcher-${VERSION}/opt/MassiveLauncher-${VERSION}_${ARCHITECTURE}/massiveLauncher.sh

tar zcf massive-launcher-${VERSION}.tar.gz massive-launcher-${VERSION}
cp massive-launcher-${VERSION}.tar.gz SOURCES/

rpmbuild -ba SPECS/massive-launcher.spec
cd ..

find rpmbuild/ -iname '*rpm' -exec ls -lh {} \;


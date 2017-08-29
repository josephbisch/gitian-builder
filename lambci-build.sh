#!/bin/sh

set -e

SQLITE_LINUX32_EXPECTED_HASH=aac8a54bff7420c68c9aa6e17deebb68c6bca612d32dc3002f19170f81f069f4
SQLITE_LINUX64_EXPECTED_HASH=b3a7d38bc49b0b958fade01a463a8f82aa6727625f3f0738e8458a8d21a1e963
SQLITE_WIN32_EXPECTED_HASH=dcf7dcf8bc58bf7e90851eab1fb80d6c82b13115ce2e05f80c532ef01ccf8cad
SQLITE_WIN64_EXPECTED_HASH=37aa44aa8e9d2852d86976dd3db4fc4edb5399529a4f88f8f8902af05cdd9011

[ -d sqlite-gitian ] && rm -rf sqlite-gitian
git clone https://github.com/JeremyRand/sqlite-gitian.git
sed -i 's/precise/trusty/g' sqlite-gitian/gitian-descriptors/sqlite-linux.yml
sed -i 's/precise/trusty/g' sqlite-gitian/gitian-descriptors/sqlite-windows.yml
[ -d sqlite-gitian ] || mkdir inputs
pushd inputs
[ -e sqlite-autoconf-3080500.tar.gz ] || wget https://www.sqlite.org/2014/sqlite-autoconf-3080500.tar.gz
popd

[ -e base-trusty-amd64.qcow2 ] || ./bin/make-base-vm --suite trusty --arch amd64
[ -e base-trusty-i386.qcow2 ] || ./bin/make-base-vm --suite trusty --arch i386
./bin/gbuild sqlite-gitian/gitian-descriptors/sqlite-linux.yml
./bin/gbuild sqlite-gitian/gitian-descriptors/sqlite-windows.yml

echo "$SQLITE_LINUX32_EXPECTED_HASH  build/out/sqlite-linux32-gitian-r1.zip" | sha256sum -c
echo "$SQLITE_LINUX64_EXPECTED_HASH  build/out/sqlite-linux64-gitian-r1.zip" | sha256sum -c
echo "$SQLITE_WIN32_EXPECTED_HASH  build/out/sqlite-win32-gitian-r1.zip" | sha256sum -c
echo "$SQLITE_WIN64_EXPECTED_HASH  build/out/sqlite-win64-gitian-r1.zip" | sha256sum -c

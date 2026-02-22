#!/bin/bash
pkgname=rapidjson
pkgver=1.1.0
if ! which wget &> /dev/null; then
	echo "wget not found and used for downloading sources"
	exit
fi

if ! which cmake &> /dev/null; then
	echo "cmake not found and used for compiling"
	exit
fi

if ! which patch &> /dev/null; then
	echo "patch not found and used as part of the build process."
	exit
fi

if ! which make &> /dev/null; then
	echo "make not found and used as part of the build process."
	exit
fi
wget -c https://github.com/miloyip/rapidjson/archive/v$pkgver/$pkgname-$pkgver.tar.gz
wget -c https://github.com/Tencent/rapidjson/commit/3b2441b8.patch
rm -rf $pkgname-$pkgver
tar xf $pkgname-$pkgver.tar.gz
cd $pkgname-$pkgver
find -name CMakeLists.txt | xargs sed -e 's|-Werror||' -i # Don't use -Werror
  patch -p1 -i ../3b2441b8.patch # Fix build with GCC 14
mkdir -p build
  cd build

  cmake \
      -DCMAKE_BUILD_TYPE=None \
      -DCMAKE_INSTALL_PREFIX:PATH=/usr \
      -DRAPIDJSON_HAS_STDSTRING=ON \
      -DRAPIDJSON_BUILD_CXX11=ON \
      -DRAPIDJSON_ENABLE_INSTRUMENTATION_OPT=OFF \
      -DDOC_INSTALL_DIR=/usr/share/doc/${pkgname}-$pkgver \
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
      ..

  make -j$(nproc)
  sudo make install



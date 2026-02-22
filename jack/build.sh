#!/bin/bash
pkgname=jack2
pkgver=1.9.22
git clone https://github.com/jackaudio/jack2
cd $pkgname
sed -i -e "s|python|python3|g" waf
./waf configure \
  --prefix=/usr \
  --libdir=/usr/lib${LIBDIRSUFFIX} \
  --mandir=/usr/man/man1 \
  --htmldir=/usr/doc/$PRGNAM-$VERSION/html \
  --classic \
  --dbus \
  --alsa
./waf build
sudo ./waf install

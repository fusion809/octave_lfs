#!/bin/bash
pkgname=jack2
pkgver=1.9.22
if ! [[ -d jack2 ]]; then
	git clone https://github.com/jackaudio/jack2
fi

cd $pkgname
git pull origin master
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

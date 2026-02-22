#!/bin/bash
pkgname=db5.3
pkgver=5.3.28
wget -c "https://download.oracle.com/berkeley-db/db-${pkgver}.tar.gz"
function ptb {
	wget -c "https://gitlab.archlinux.org/archlinux/packaging/packages/db5.3/-/raw/main/$1?ref_type=heads&inline=false" -O "$1"
}
ptb "db-5.3.21-memp_stat-upstream-fix.patch" 
ptb "db-5.3.21-mutex_leak.patch"
ptb "db-5.3.28-lemon_hash.patch"
ptb "db-5.3.28_cve-2019-2708.patch"
ptb "db-5.3.28-mmap-high-cpu-usage.patch"
ptb "db-5.3.28-atomic_compare_exchange.patch"
ptb "db-5.3.28-fcntl-mutexes-bdb4.8.patch"
ptb "db-5.3.28-tls-configure.patch"
tar xf "db-${pkgver}.tar.gz"
cd db-$pkgver/build_unix
export CFLAGS+=" -std=gnu99"
  ../dist/configure \
    --prefix=/usr \
    --bindir=/usr/bin/db5.3 \
    --includedir=/usr/include/db5.3 \
    --enable-compat185 \
    --enable-shared \
    --disable-static \
    --enable-cxx \
    --enable-dbm \
    --enable-stl
  make -j$(nproc) LIBSO_LIBS=-lpthread
sudo make install
sudo su -c 'install -Dm644 db-${pkgver}/LICENSE /usr/share/licenses/${pkgname}/LICENSE
  install -d /usr/lib/db5.3
  rm /usr/lib/libdb.so
  rm /usr/lib/libdb_cxx.so
  rm /usr/lib/libdb_stl.so
  ln -s ../libdb-5.3.so /usr/lib/db5.3/libdb.so
  ln -s ../libdb_cxx-5.3.so /usr/lib/db5.3/libdb_cxx.so
  ln -s ../libdb_stl-5.3.so /usr/lib/db5.3/libdb_stl.so'

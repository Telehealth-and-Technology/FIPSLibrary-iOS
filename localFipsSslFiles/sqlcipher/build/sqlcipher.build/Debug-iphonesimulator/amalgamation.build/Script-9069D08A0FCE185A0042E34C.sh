#!/bin/sh
./configure --enable-tempstore=yes --with-crypto-lib=commoncrypto CFLAGS="-DSQLITE_HAS_CODEC -DSQLITE_TEMP_STORE=2"
make sqlite3.c
exit 0

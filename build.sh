#!/bin/sh
set -e

PKGVER=$(grep '^pkgver=' APKBUILD | cut -d= -f2)
GITTAG=$(git describe --exact-match --tags HEAD 2>/dev/null | sed 's/^v//')

if [ -z "$GITTAG" ]; then
    echo "error: HEAD ist kein getaggter Commit" >&2
    exit 1
fi

if [ "$PKGVER" != "$GITTAG" ]; then
    echo "error: pkgver ($PKGVER) stimmt nicht mit Git-Tag ($GITTAG) überein" >&2
    exit 1
fi

abuild checksum
abuild -r

REPODEST="${REPODEST:-$HOME/packages}"
find "$REPODEST" -name "simple-http-announcer-$PKGVER-*.apk" \
    -exec cp {} /srv/packages/alpine/x86_64/ \;

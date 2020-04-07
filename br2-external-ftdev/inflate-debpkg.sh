#!/bin/sh

if ! [ -f "$1" ]; then
	echo "${0##*/}: cannot find package \`$1'" >&2
	exit 1
fi
ar p $1 data.tar.gz | gzip -d -c

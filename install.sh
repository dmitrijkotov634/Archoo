#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
	echo "Must be run as root"
	exit 1
fi
	cp src/archoo /usr/bin/archoo
	chmod 755 /usr/bin/archoo

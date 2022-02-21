#!/bin/sh
set -e

wd=${1:-/ctr_cfg}

bd=${2:-/tmp}
bd=$bd/`date "+%Y%m%d"`

# Create a directory for today
mkdir $bd

echo "Working Directory: $wd"
echo "Backup Directory: $bd"

cd $wd

for d in */ ; do
	# Remove trailing slash from directory
	d=${d%/}
	echo "Backing up $d"
	tar -czf $bd/$d.tgz $d
done


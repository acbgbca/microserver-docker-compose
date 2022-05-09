#!/bin/sh
set -e

wd=${1:-/ctr_cfg}

bd=${2:-/tmp}
bd=$bd/`date "+%Y%m%d"`

# Create a directory for today
mkdir -p $bd

echo "Working Directory: $wd"
echo "Backup Directory: $bd"

cd $wd

# Before we start, clean up the plex cache
# This removes all cache files older than 5 days
find "./plex/config/Library/Application Support/Plex Media Server/Cache/PhotoTranscoder" -type f -mtime +5 -delete

for d in */ ; do
	# Remove trailing slash from directory
	d=${d%/}
	echo "Backing up $d"
	if [ $d = "plex" ]
	then
		# Exclude paths not required for rsetore
		tar --exclude='config/Library/Application Support/Plex Media Server/Cache' --exclude='config/Library/Application Support/Plex Media Server/Crash Reports' --exclude='config/Library/Application Support/Plex Media Server/Logs' --exclude='config/Library/Application Support/Plex Media Server/Media' -czf $bd/$d.tgz $d
	else
		tar -czf $bd/$d.tgz $d
	fi
done


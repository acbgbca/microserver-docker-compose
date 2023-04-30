#!/bin/sh
set -e

wd=${1:-/ctr_cfg}
date=`date "+%Y%m%d"`

bd=${2:-/tmp/backup}
bd=$bd/$date

# Create a directory for today
mkdir -p $bd
su -c "mkdir -p /mnt/backup/$date/" ctrdata

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
	cd $d
	docker-compose down
	if [ $d = "plex" ]
	then
		# Exclude paths not required for restore
		tar --exclude='config/Library/Application Support/Plex Media Server/Cache' --exclude='config/Library/Application Support/Plex Media Server/Crash Reports' --exclude='config/Library/Application Support/Plex Media Server/Logs' --exclude='config/Library/Application Support/Plex Media Server/Media' -czf $bd/$d.tgz ../$d
	else
		tar -czf $bd/$d.tgz ../$d
	fi
	su -c "cp $bd/$d.tgz /mnt/backup/$date/" ctrdata

	if [ -f ".no_upgrade" ]; then
		echo "Skipping $d"
	else
		echo "Upgrading $d"
		docker-compose pull --ignore-pull-failures

		docker-compose up -d --remove-orphans
	fi
	cd ..
done

# Remove old images
docker image prune -f

rm $bd/*.tgz

rmdir $bd

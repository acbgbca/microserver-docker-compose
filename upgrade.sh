#!/bin/sh
set -e

wd=${1:-/ctr_cfg}

cd $wd

for d in */ ; do
	echo "Upgrading $d"
	cd $d
	# Download updated containers
	docker-compose pull

	# Upgrade container if required
	docker-compose up -d --remove-orphans
	cd ..
done

# Remove old images
docker image prune -f


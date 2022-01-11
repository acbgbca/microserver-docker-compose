#!/bin/bash

set -e

if [ "$1" == "-h" ]; then
  echo "Usage: fix-permissions.sh [user] [group] [working directory]";
  echo "Either all values need to be provided, or none (values will default if not provided)";
  exit 0;
fi

USER=${1:-ctrdata};
GROUP=${2:-ctrdata};
WORKDIR=${3:-$PWD};

# First, ensure everything is owned by the provided user and group
chown -R $USER.$GROUP $WORKDIR;

# Next, ensure the file permissions are correct (rw for user and group).
# We use add rather than set to avoid accidentally removing execute permissions from any files that require it.
chmod -R u+rw,g+rw $WORKDIR;

# Lastly, fix the directory permissions (directories need execute in addition to read/write)
find $WORKDIR -type d -exec chmod 775 {} \;

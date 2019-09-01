#!/usr/bin/env sh

set -e

SRC="$1"
DST="$2"

echo "Are you ready to sync ${SRC} to ${DST} (y/n)?"
read CONFIRM

if [ "${CONFIRM}" != "y" ]; then
  echo "You said \"${CONFIRM}\", that means you are not sure, then exit."
  exit 0
fi

echo "Sync..."

rsync --archive --progress "${SRC}"/* "${DST}"

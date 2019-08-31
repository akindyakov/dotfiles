#!/usr/bin/env sh

set -e

ARGS="$@"

if [ "$ARGS" == "-h" ] || [ "$ARGS" == "--help" ]; then
  openssl enc -help
  echo "---"
  echo "Usage:"
  echo " For encryption: $0 -in <input> -out <output>"
  echo " For decryption: $0 -d -in <input> -out <output>"
  exit 0
fi

set -x

openssl enc -pbkdf2 -aes-256-cbc "$@"

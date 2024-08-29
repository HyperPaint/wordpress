#!/bin/bash

source "/root/scripts/log.sh"

killall "php-fpm"

for file in /var/run/php-fpm/*; do
  rm -rf "$file"
  if [ $? ]; then
    log "Removed $file"
  else
    log "Can't remove $file"
    return 1
  fi
done

#!/bin/bash

source "/root/scripts/log.sh"

killall "httpd"

for file in /var/run/httpd/*; do
  rm -rf "$file"
  if [ $? ]; then
    log "Removed $file"
  else
    log "Can't remove $file"
    return 1
  fi
done

#!/bin/bash

source "/root/scripts/log.sh"

healthcheck() {
  curl -f "http://localhost:80"
  return $?
}

if healthcheck; then
  log "Healthcheck OK"
  exit 0
else
  error "Healthcheck ERROR"
  exit 1
fi
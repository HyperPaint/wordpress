#!/bin/sh

log() {
  # ISO-8601
  echo "[$(date '+%FT%TZ')] [$0] $1"
}

error() {
  # ISO-8601
  echo "[$(date '+%FT%TZ')] [$0] $1" 1>&2
}

healthcheck() {
  curl -f http://localhost:80/
  return $?
}

if healthcheck; then
  log "READY"
  exit 0
else
  error "NOT READY"
  exit 1
fi
#!/bin/bash

pid=$$

trap "stop_app" 2 15

source "/root/scripts/log.sh"

prepare_app() {
    log "Preparing..."
    prepare_date=$(date "+%s")
    ### Начало ###

    source "/root/scripts/prepare.sh"

    ### Конец ###
    wait
    prepared_time=$(echo "$(date '+%s') - $prepare_date" | bc)
    log "Prepared in $prepared_time seconds"
    return 0
}

start_app() {
  log "Starting..."
  start_date=$(date "+%s")
  ### Начало ###

  source "/root/scripts/start.sh"

  ### Конец ###
  pid=$!
  if [ $pid = -1 ]; then
    return 1
  else
    started_time=$(echo "$(date '+%s') - $start_date" | bc)
    log "Started in $started_time seconds"
    wait
    return 0
  fi
}

stop_app() {
  log "Stopping..."
  stop_date=$(date "+%s")
  
  source "/root/scripts/stop.sh"

  stopped_time=$(echo "$(date '+%s') - $stop_date" | bc)
  log "Stopped in $stopped_time seconds"
  return 0
}

sleep_app() {
  error "Something went wrong"
  error "Sleeping 10 minutes..."
  sleep "10m"
  exit 1
}

if prepare_app; then
    start_app
else
    sleep_app
fi

log "Exited"
log "..."

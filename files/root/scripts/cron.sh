#!/bin/bash

while true; do
  sleep 10
  curl -sf http://localhost/wp-cron.php
done

#!/bin/bash

php-fpm -F &
httpd -DFOREGROUND &
~/scripts/cron.sh &

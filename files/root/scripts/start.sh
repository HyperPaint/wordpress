#!/bin/bash

php-fpm -F &
httpd -DFOREGROUND &

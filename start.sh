#!/bin/bash

# Starts Nginx
service nginx start

# Logging
tail -f /var/log/nginx/error.log /var/log/nginx/access.log

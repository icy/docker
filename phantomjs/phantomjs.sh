#!/bin/bash

fc-cache

exec /usr/bin/phantomjs --webdriver=8190 --debug=${PHANTOMJS_DEBUG:-false}

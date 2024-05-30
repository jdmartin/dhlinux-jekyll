#!/usr/bin/env bash

# Load .env file
if [ -f .env ]; then
    export $(cat .env | sed 's/#.*//g' | xargs)
else
    echo ".env file not found!"
    exit 1
fi

bundle exec jekyll serve -H $HOST --port 8083 --config _config.yml,_config_dev.yml --watch --drafts --destination _dev_build;

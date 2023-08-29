#!/usr/bin/env bash

bundle exec jekyll serve -H 0.0.0.0 --port 8083 --config _config.yml,_config_dev.yml --watch --drafts --destination _dev_build;

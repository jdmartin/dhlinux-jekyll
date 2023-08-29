#!/usr/bin/env bash

docker run --rm -it --security-opt=no-new-privileges \
  --name dhwiki \
  --platform linux/amd64 \
  --volume=".:/srv/jekyll" \
  --volume="./vendor/bundle:/usr/local/bundle" \
  -p 4000:4000 \
  jekyll/jekyll \
  bundle install; bundle exec jekyll build --config _config.yml --incremental

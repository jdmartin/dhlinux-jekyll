#!/usr/bin/env bash

docker run --rm -it --security-opt=no-new-privileges \
  --name dhwiki \
  --platform linux/amd64 \
  --volume=".:/srv/jekyll" \
  --volume="./vendor/bundle:/usr/local/bundle" \
  -p 4000:4000 \
  jekyll/jekyll \
  bundle update --bundler; bundle install; bundle exec jekyll serve --config _config.yml,_config_dev.yml --watch --drafts -o

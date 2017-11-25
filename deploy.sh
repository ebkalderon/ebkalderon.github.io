#!/bin/bash

if [ $TRAVIS_PULL_REQUEST == "true" ]; then
  exit 0
fi

set -e

rm -rf _site
mkdir _site

git clone https://${GITHUB_TOKEN}@github.com/ebkalderon/ebkalderon.github.com.git _site

cd _site
bundle install
bundle exec jekyll build

git config user.name "Eyal Kalderon"
git config user.email "ebkalderon@gmail.com"
git add --all
git commit -am "Travis #$TRAVIS_BUILD_NUMBER"
git push --force origin gh-pages

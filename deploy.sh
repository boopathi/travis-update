#!/bin/bash

set -e

function run_benchmark() {
  npm run benchmark
}

if [ "$CI" != "true" -o "$TRAVIS" != "true" ]; then
  echo "Skipping benchmark - Environment is not Travis. Use npm run benchmark"
  exit 0
fi

if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
  echo "Skipping benchmark - pull request"
  exit 0
fi

if [ "$TRAVIS_BRANCH" != "master" ]; then
  echo "Skipping benchmark - branch is not master"
  exit 0
fi

REPO=`git config remote.origin.url`

rm -rf tmp || exit 0
mkdir tmp
echo "Running benchmarks..."
run_benchmark

( git clone $REPO tmp
  cd tmp

  echo "Configuring..."
  git config user.name "Travis CI"
  git config user.email "$COMMIT_AUTHOR_EMAIL"
  git config credential.helper "store --file=.git/credentials"
  echo "https://${GH_TOKEN}:@github.com" > .git/credentials

  echo "Copying changes..."
  cp ../benchmarks.md ./benchmarks.md

  echo "Committing changes..."
  git add .
  git commit -m "[skip ci] Update Benchmark for ${TRAVIS_COMMIT}"

  echo "Pushing commit to master..."
  git push --quiet origin master > /dev/null 2>&1

  echo "Done"
)
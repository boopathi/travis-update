#!/bin/bash

function run_benchmark() {
  npm run benchmark
}

if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
  echo "Skipping benchmark"
  exit 0
fi

REPO=`git config remote.origin.url`
GH_REF=${REPO/git@github.com:/github.com\/}

rm -rf tmp || exit 0
mkdir tmp
run_benchmark
( git clone $REPO tmp
  cd tmp
  git config user.name "Travis CI"
  git config user.email "$COMMIT_AUTHOR_EMAIL"
  cp ../benchmarks.md ./benchmarks.md
  git add .
  git commit -m "[skip ci] Update Benchmark"
  echo "Trying to deploy"
  git push --force --quiet "https://${GH_TOKEN}@${GH_REF}" > /dev/null 2>&1
  echo $?
)

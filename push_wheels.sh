#!/bin/bash

set -e

export BUILD_BRANCH="builder"
export PUBLISH_BRANCH="master"
export REPO="$TRAVIS_REPO_SLUG"

if [ "x$TRAVIS_PULL_REQUEST" == "xfalse" ] && [ "x$TRAVIS_BRANCH" == "x$BUILD_BRANCH" ]; then

    echo "Pushing to ${PUBLISH_BRANCH}."

    git config --global user.email "travis@travis-ci.org"
    git config --global user.name "travis-ci"
    git clone --quiet --branch=${PUBLISH_BRANCH} https://${GH_TOKEN}@github.com/${REPO} travis-wheels > /dev/null

    cd travis-wheels
    rm -rf wheelhouse
    mkdir wheelhouse
    cp -Rf ${wheelhouse}/*.whl wheelhouse/
    git status
    git add wheelhouse wheelhouse/*.whl
    git commit -m "Latest wheels build by travis-ci."
    git status
    git push origin ${PUBLISH_BRANCH} > /dev/null
else
    echo "Not pushing to ${PUBLISH_BRANCH}. In PR: ${TRAVIS_PULL_REQUEST}; Branch: ${TRAVIS_BRANCH};"
fi
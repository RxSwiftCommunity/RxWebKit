#!/usr/bin/env bash

set -euo pipefail
git config --global user.name "RxWebKit Maintainers"
git config --global user.email "RxWebKit@rxswift.org"
npx standard-version
echo "RELEASE_VERSION=$(git describe --abbrev=0 | tr -d '\n')" >> $GITHUB_ENV
export VERSION="$(git describe --abbrev=0 | tr -d '\n')"
VERSION=${VERSION:1}
echo $VERSION
npx podspec-bump -w -i "$VERSION"
git add -A
git commit --amend --no-edit
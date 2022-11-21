#!/bin/bash

set -e

Version=$(npm info axe-core version)
Packages=$(find . -name "package.json" -not -path "*/node_modules/*")
PreviousVersion=""
for Package in $Packages; do
  Dir=$(dirname "$Package")

  echo "Updating package '$Dir'..."
  cd "$Dir" || exit 1

  RuntimeVersion=$(jq -r '.dependencies["axe-core"]' package.json)
  DevelopmentVersion=$(jq -r '.devDependencies["axe-core"]' package.json)

  if [ "$RuntimeVersion" != "null" ]; then
    if [ -z "$PreviousVersion" ]; then
      PreviousVersion="$RuntimeVersion"
    fi

    if [ -f yarn.lock ]; then
      yarn add "axe-core@^$Version"
    else
      npm install --save "axe-core@^$Version"
    fi
  elif [ "$DevelopmentVersion" != "null" ]; then
    if [ -z "$PreviousVersion" ]; then
      PreviousVersion="$DevelopmentVersion"
    fi

    if [ -f yarn.lock ]; then
      yarn add --dev "axe-core@^$Version"
    else
      npm install --save-dev "axe-core@^$Version"
    fi
  else
    echo "No axe-core dependency found."
  fi

  cd - || exit 1
done

CleanVersion=$(echo "$PreviousVersion" | tr -cd '[:alnum:]._-')
echo "version=$Version" >>"$GITHUB_OUTPUT"
echo "previous_version=$CleanVersion" >>"$GITHUB_OUTPUT"

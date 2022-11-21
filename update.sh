#!/bin/bash

set -e

Version=$(npm info axe-core version)
Packages=$(find . -name "package.json" -not -path "*/node_modules/*")
for Package in $Packages; do
  Dir=$(dirname "$Package")

  echo "Updating package '$Dir'..."
  cd "$Dir" || exit 1

  IsRuntimeDependency=$(jq '.dependencies["axe-core"]' package.json)
  IsDevelopmentDependency=$(jq '.devDependencies["axe-core"]' package.json)

  if [ "$IsRuntimeDependency" != "null" ]; then
    if [ -f yarn.lock ]; then
      yarn add "axe-core@$Version"
    else
      npm install --save "axe-core@$Version"
    fi
  elif [ "$IsDevelopmentDependency" != "null" ]; then
    if [ -f yarn.lock ]; then
      yarn add --dev "axe-core@$Version"
    else
      npm install --save-dev "axe-core@$Version"
    fi
  else
    echo "No axe-core dependency found."
  fi

  cd - || exit 1
done

echo "version=$Version" >>$GITHUB_OUTPUT

echo "Done..."

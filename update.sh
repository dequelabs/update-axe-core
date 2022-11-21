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

echo "version=$Version" >>"$GITHUB_OUTPUT"

CleanVersion=$(echo "$PreviousVersion" | tr -cd '[:alnum:]._-')
echo "previous_version=$CleanVersion" >>"$GITHUB_OUTPUT"

PreviousParts=(${CleanVersion//./ })
PreviousMajorVersion="${PreviousParts[0]}"
PreviousMinorVersion="${PreviousParts[1]}"
PreviousPatchVersion="${PreviousParts[2]}"

Parts=(${Version//./ })
MajorVersion="${Parts[0]}"
MinorVersion="${Parts[1]}"
PatchVersion="${Parts[2]}"

if [ "$PreviousMajorVersion" != "$MajorVersion" ]; then
  echo "major_version_updated=true" >>"$GITHUB_OUTPUT"
  echo "minor_version_updated=false" >>"$GITHUB_OUTPUT"
  echo "patch_version_updated=false" >>"$GITHUB_OUTPUT"
elif [ "$PreviousMinorVersion" != "$MinorVersion" ]; then
  echo "major_version_updated=false" >>"$GITHUB_OUTPUT"
  echo "minor_version_updated=true" >>"$GITHUB_OUTPUT"
  echo "patch_version_updated=false" >>"$GITHUB_OUTPUT"
elif [ "$PreviousPatchVersion" != "$PatchVersion" ]; then
  echo "major_version_updated=false" >>"$GITHUB_OUTPUT"
  echo "minor_version_updated=false" >>"$GITHUB_OUTPUT"
  echo "patch_version_updated=true" >>"$GITHUB_OUTPUT"
else
  echo "major_version_updated=false" >>"$GITHUB_OUTPUT"
  echo "minor_version_updated=false" >>"$GITHUB_OUTPUT"
  echo "patch_version_updated=false" >>"$GITHUB_OUTPUT"
fi

#!/bin/bash

# JavaScript include Preprocessor
#
if [ -z "$1" ]
  then
    echo >&2 "No file given"
    echo >&2 "Usage: $0 <js-file>"
    exit 1
fi

i=0
while read line
  do
    if [[ $line == *"#include"* ]]; then
      temp=${line##*"#include(\""}
      packages[$i]=${temp%%"\");"}
    fi
  done < $1


IFS=
for p in $packages
  do
    code=$(cat "node_modules/$p/$p.js")
    # escape all backslashes first
    escaped="${code//\\/\\\\}"

    # escape slashes
    escaped="${escaped//\//\\/}"

    # escape asterisks
    escaped="${escaped//\*/\\*}"

    # escape full stops
    escaped="${escaped//./\\.}"

    # escape [ and ]
    escaped="${escaped//\]/\\]}"
    escaped="${escaped//\[/\\[}"

    # escape ^ and $
    escaped="${escaped//^/\\^}"
    escaped="${escaped//\$/\\\$}"

    sed "/#include(\"$p\")/c\ ${escaped//$'\n'/\\$'\n'}" $1 > "$1.preprocessed"
  done

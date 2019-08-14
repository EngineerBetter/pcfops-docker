#!/bin/bash
set -eux

names=( terraform cf jq om fly bosh bbl yq credhub certstrap yaml2json)
for name in "${names[@]}"
do
  chmod +x /usr/bin/$name
  sync # docker bug requires this

  # See https://github.com/wakeful/yaml2json/issues/4
  if [ "$name" == "yaml2json" ]; then
    set +e
  fi

  $name --version

  if [ "$name" == "yaml2json" ]; then
    set -e
  fi
done

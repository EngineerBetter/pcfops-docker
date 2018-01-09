#!/bin/bash
set -eux

names=( terraform cf jq om fly bosh bbl yaml credhub certstrap)
for name in "${names[@]}"
do
  chmod +x /usr/bin/$name
  sync # docker bug requires this
  $name --version
done

#!/bin/bash
set -eux

names=( terraform cf jq om fly bosh bbl )
for name in "${names[@]}"
do
  chmod +x /usr/bin/$name
  $name --version
done

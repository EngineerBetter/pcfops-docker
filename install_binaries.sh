#!/bin/bash
set -eux

names=( terrraform cf jq om fly bosh bbl )
for name in "${names[@]}"
do
  chmod +x /usr/bin/$name
  $name --version
done

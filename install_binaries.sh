#!/bin/bash
set -eux

names=( terraform cf jq om fly bosh bbl yaml cliaas )
for name in "${names[@]}"
do
  chmod +x /usr/bin/$name
done

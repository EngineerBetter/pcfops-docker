#!/bin/bash
set -eux

names=( terraform cf jq om fly bosh bbl yq credhub certstrap yaml2json helm golangci-lint bbr kapp ytt)
for name in "${names[@]}"
do
  chmod +x /usr/bin/$name
  sync # docker bug requires this

  # Helm is special. Very special.
  if [ "$name" != "helm" ]
  then
    $name --version
  fi
done

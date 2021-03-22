#!/bin/bash
set -eux

names=( terraform cf jq om fly bosh bbl yq credhub certstrap yaml2json helm golangci-lint bbr kapp ytt kf)
for name in "${names[@]}"
do
  chmod +x /usr/bin/$name
  sync # docker bug requires this

  if [[ "$name" =~ helm|kf|bbr ]]
  then
    $name version
  else
    $name --version
  fi
done

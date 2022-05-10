#!/bin/bash
set -eux

names=( terraform cf jq om fly bosh bbl yq credhub certstrap yaml2json helm golangci-lint bbr kapp ytt kf kubectl kbld)
for name in "${names[@]}"
do
  chmod +x /usr/bin/$name
  sync # docker bug requires this
  if [[ "$name" = kubectl ]]
  then
    $name version --client=true
  elif [[ "$name" =~ helm|kf|bbr ]]
  then
    $name version
  else
    $name --version
  fi
done

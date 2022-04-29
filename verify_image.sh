#!/bin/bash

set -eux
echo "Executing $0"

command -v \
  aws \
  bbl \
  bbr \
  bosh \
  certstrap \
  cf \
  credhub \
  fly \
  gcloud \
  ginkgo \
  go \
  gometalinter \
  golangci-lint \
  gpg \
  helm \
  jq \
  kapp \
  kbld \
  kf \
  kpt \
  kubectl \
  om \
  parallel \
  prolific \
  python \
  ruby \
  shellcheck \
  stopover \
  stopover.v2 \
  terraform \
  uaac \
  yaml-patch \
  yaml2json \
  yml2env \
  yq \
  ytt

echo "GOPATH is $GOPATH"

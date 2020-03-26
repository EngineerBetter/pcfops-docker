#!/bin/bash

set -eux

command -v \
  aws \
  bbl \
  bosh \
  certstrap \
  cf \
  credhub \
  fly \
  gcloud \
  ginkgo \
  go \
  gometalinter \
  gpg \
  jq \
  om \
  parallel \
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
  bbr

echo "GOPATH is $GOPATH"

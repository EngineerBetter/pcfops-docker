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
  yml2env \
  yq

echo "GOPATH is $GOPATH"

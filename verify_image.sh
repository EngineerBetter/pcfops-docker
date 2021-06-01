#!/bin/bash

set -eux

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
  gpg \
  jq \
  kapp \
  kf \
  kpt \
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

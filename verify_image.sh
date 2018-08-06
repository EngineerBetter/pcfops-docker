#!/bin/bash

set -eux

command -v terraform \
  cf \
  jq \
  om \
  fly \
  bosh \
  bbl \
  yaml \
  yq \
  credhub \
  certstrap \
  python \
  parallel \
  shellcheck \
  aws \
  go \
  ginkgo \
  gometalinter \
  stopover \
  yaml-patch \
  yml2env \
  ruby \
  uaac

echo "GOPATH is $GOPATH"

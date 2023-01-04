#!/bin/bash

set -eux
echo "Executing $0"

# Initialise rbenv
eval "$(rbenv init -)"

aws --version
bbl version
bbr version
bosh --version
certstrap --version
cf version
credhub --version |grep CLI
fly -version
gcloud version
ginkgo version
go version
gometalinter --version
golangci-lint version
gpg --version
helm version
jq --version
kapp --version
kbld --version
kf version
kpt version
kubectl version --client
om version
parallel --version
prolific |head -n1
ruby --version
shellcheck --version
which stopover
which stopover.v2
terraform version
uaac --version
yaml-patch --help
yaml2json -version
which yml2env
yq --version
ytt --version

echo "GOPATH is $GOPATH"

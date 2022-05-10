FROM cloudfoundry/cflinuxfs3

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
ARG GO111MODULE=auto

# Copy in GO and AWS source files
COPY go.tar.gz awscli-exe-linux-x86_64.zip ./

# Unpack and install GO
RUN tar -C /usr/local -xzf go.tar.gz \
  && rm go.tar.gz \
  && mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

# Copy in binaries and make sure they are executable
# CHORE: we're triplicating(!) this list also in install_binaries and verify_image (and missing out there)
COPY terraform cf jq om fly bosh bbl yq credhub certstrap helm yaml2json golangci-lint bbr kapp kbld ytt kf kubectl /usr/bin/
COPY install_binaries.sh .
RUN ./install_binaries.sh && rm install_binaries.sh

# Configure sources list so that apt-get can find the gcp SDK
RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"  \
  && echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list  \
  && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
  && cat /etc/apt/sources.list.d/google-cloud-sdk.list

# Install tooling from ubuntu packages
RUN apt-get update && apt-get install -y --no-install-recommends \
  parallel \
  postgresql \
  ruby-dev \
  gnupg2 \
  shellcheck \
  google-cloud-sdk \
  && rm -rf /var/lib/apt/lists/*

# Symlinks required by postgres
RUN ln -s /usr/lib/postgresql/*/bin/initdb /usr/bin/initdb && ln -s /usr/lib/postgresql/*/bin/postgres /usr/bin/postgres

# Install AWS CLI
RUN unzip -q awscli-exe-linux-x86_64.zip \
  && rm awscli-exe-linux-x86_64.zip \
  && ./aws/install \
  && rm -r aws \
  && aws --version

RUN go get github.com/onsi/ginkgo \
  github.com/onsi/gomega \
  gopkg.in/onsi/prolific.v2 \
  gopkg.in/alecthomas/gometalinter.v2 \
  github.com/EngineerBetter/yaml-patch/cmd/yaml-patch \
  github.com/EngineerBetter/yml2env \
  github.com/santhosh-tekuri/jsonschema/cmd/jv \
  gopkg.in/EngineerBetter/stopover.v2 \
  gopkg.in/EngineerBetter/stopover.v1 \
  && mv /go/bin/prolific.v2 /go/bin/prolific \
  && mv /go/bin/stopover.v1 /go/bin/stopover

# Install gometalinter
RUN mv /go/bin/gometalinter.v2 /go/bin/gometalinter && \
  gometalinter --install

# install kpt
RUN go install github.com/GoogleContainerTools/kpt@latest

# Install uaac
RUN gem install --no-document --no-update-sources --verbose cf-uaac \
  && rm -rf /usr/lib/ruby/gems/2.5.0/cache/

COPY verify_image.sh /tmp/verify_image.sh
RUN /tmp/verify_image.sh && rm /tmp/verify_image.sh

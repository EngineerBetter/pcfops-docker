FROM cloudfoundry/cflinuxfs3

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
ARG GO111MODULE=auto
ARG RUBY_VERSION=3.2.0


# Copy in GO and AWS source files
COPY go.tar.gz awscli-exe-linux-x86_64.zip ./

# Unpack and install GO
RUN tar -C /usr/local -xzf go.tar.gz \
  && rm go.tar.gz \
  && mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

# Copy in binaries and make sure they are executable
# We need to duplicate the binaries as there's no way to pass a list to COPY
COPY      bbl bbr bosh certstrap cf credhub fly golangci-lint helm jq kapp kbld kf kubectl om terraform yaml2json yq ytt /usr/bin/
ENV BINS="bbl bbr bosh certstrap cf credhub fly golangci-lint helm jq kapp kbld kf kubectl om terraform yaml2json yq ytt"
RUN for b in ${BINS}; do \
  chmod +x /usr/bin/$b; \
  done

# Install cosign
COPY cosign.deb /tmp
RUN dpkg -i /tmp/cosign.deb

# Configure sources list so that apt-get can find the gcp SDK
RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"  \
  && echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list  \
  && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
  && cat /etc/apt/sources.list.d/google-cloud-sdk.list

# Install tooling from ubuntu packages
RUN apt-get update && apt-get install -y --no-install-recommends \
  parallel \
  postgresql \
  gnupg2 \
  shellcheck \
  git-crypt \
  google-cloud-sdk \
  google-cloud-sdk-gke-gcloud-auth-plugin \
  && rm -rf /var/lib/apt/lists/*

# Symlinks required by postgres
RUN ln -s /usr/lib/postgresql/*/bin/initdb /usr/bin/initdb && ln -s /usr/lib/postgresql/*/bin/postgres /usr/bin/postgres

# Install AWS CLI
RUN unzip -q awscli-exe-linux-x86_64.zip \
  && rm awscli-exe-linux-x86_64.zip \
  && ./aws/install \
  && rm -r aws

RUN go install github.com/onsi/ginkgo/v2/ginkgo@latest && \
  go get github.com/onsi/gomega \
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

# Install later ruby version
RUN git clone https://github.com/rbenv/rbenv.git /root/.rbenv \
  && git clone https://github.com/rbenv/ruby-build.git /root/.rbenv/plugins/ruby-build \
  && /root/.rbenv/plugins/ruby-build/install.sh \
  && echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh \
  && echo 'eval "$(rbenv init -)"' >> $HOME/.bashrc \
  && echo 'eval "$(rbenv init -)"' >> $HOME/.bash_profile

ENV CONFIGURE_OPTS --disable-install-doc
ENV PATH /root/.rbenv/bin:$PATH

RUN rbenv install ${RUBY_VERSION} \
  && rbenv global ${RUBY_VERSION}

# Install uaac
RUN bash -l -c 'gem update --system' \
  && bash -l -c 'gem update' \
  && bash -l -c 'gem install --no-document --no-update-sources --verbose cf-uaac' \
  && rm -rf /usr/lib/ruby/gems/2.5.0/cache/ \
  && rm -rf /root/.rbenv/versions/*/lib/ruby/gems/*/cache

COPY verify_image.sh /tmp/verify_image.sh
RUN /tmp/verify_image.sh && rm /tmp/verify_image.sh

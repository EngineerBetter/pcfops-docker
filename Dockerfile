FROM cloudfoundry/cflinuxfs2

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

COPY terraform /usr/bin/terraform
COPY cf /usr/bin/cf
COPY jq /usr/bin/jq

RUN chmod +x /usr/bin/terraform
RUN chmod +x /usr/bin/cf
RUN chmod +x /usr/bin/jq

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gettext \
    groff \
    libreadline6 \
    libreadline6-dev \
    libsqlite3-dev \
    libssl-dev \
    libxml2-dev \
    libxslt-dev \
    libyaml-dev \
    openssl \
    python-dev \
    python-pip \
    sqlite3 \
    unzip \
    vim \
    zlib1g-dev \
    zlibc

RUN pip install --upgrade pip \
    && pip install --upgrade virtualenv \
    && pip install awscli

RUN wget https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-2.0.24-linux-amd64 \
    && mv bosh-cli-2.0.24-linux-amd64 /usr/bin/bosh2 \
    && chmod +x /usr/bin/bosh2 \
    && ln /usr/bin/bosh2 /usr/bin/bosh

RUN wget https://github.com/concourse/concourse/releases/download/v3.0.1/fly_linux_amd64 \
    && mv fly_linux_amd64 /usr/bin/fly \
    && chmod +x /usr/bin/fly

ENV OM_VERSION=0.26.0
RUN wget https://github.com/pivotal-cf/om/releases/download/$OM_VERSION/om-linux \
    && mv om-linux /usr/bin/om \
    && chmod +x /usr/bin/om

RUN wget https://github.com/cloudfoundry/bosh-bootloader/releases/download/v4.7.3/bbl-v4.7.3_linux_x86-64 \
    && mv bbl-v4.7.3_linux_x86-64 /usr/bin/bbl \
    && chmod +x /usr/bin/bbl

RUN curl -fsSL "https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz" -o golang.tar.gz \
    && echo "1862f4c3d3907e59b04a757cfda0ea7aa9ef39274af99a784f5be843c80c6772 golang.tar.gz" | sha256sum -c - \
    && tar -C /usr/local -xzf golang.tar.gz \
    && rm golang.tar.gz \
    && mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

RUN go get -d github.com/onsi/ginkgo \
 && cd $GOPATH/src/github.com/onsi/ginkgo \
 && git checkout v1.4.0 \
 && go install github.com/onsi/ginkgo/ginkgo \
 && rm -rf $GOPATH/src/* $GOPATH/pkg/*

RUN gem install --no-document --no-update-sources --verbose cf-uaac \
    && rm -rf /usr/lib/ruby/gems/2.3.0/cache/

RUN go get github.com/EngineerBetter/stopover

ENV YAML_VERSION=1.13.1
RUN wget "https://github.com/mikefarah/yaml/releases/download/${YAML_VERSION}/yaml_linux_amd64" \
    && mv yaml_linux_amd64 /usr/bin/yaml \
    && chmod +x /usr/bin/yaml

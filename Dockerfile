FROM cloudfoundry/cflinuxfs2

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

COPY terraform /usr/bin/terraform
COPY cf /usr/bin/cf
COPY jq /usr/bin/jq
COPY om /usr/bin/om
COPY fly /usr/bin/fly
COPY bosh /usr/bin/bosh
COPY bbl /usr/bin/bbl
COPY yaml /usr/bin/yaml
COPY install_binaries.sh .
RUN ./install_binaries.sh


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

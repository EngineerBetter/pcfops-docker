FROM cloudfoundry/cflinuxfs2

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
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

RUN wget https://releases.hashicorp.com/terraform/0.9.5/terraform_0.9.5_linux_amd64.zip \
    && unzip terraform_0.9.5_linux_amd64.zip \
    && rm terraform_0.9.5_linux_amd64.zip \
    && chmod +x terraform \
    && mv terraform /usr/bin/terraform

RUN wget https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-2.0.16-linux-amd64 \
    && mv bosh-cli-2.0.16-linux-amd64 /usr/bin/bosh2 \
    && chmod +x /usr/bin/bosh2

RUN wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 \
    && mv jq-linux64 /usr/bin/jq \
    && chmod +x /usr/bin/jq

RUN wget https://github.com/concourse/concourse/releases/download/v3.0.1/fly_linux_amd64 \
    && mv fly_linux_amd64 /usr/bin/fly \
    && chmod +x /usr/bin/fly

RUN wget https://github.com/pivotal-cf/om/releases/download/0.23.0/om-linux \
    && mv om-linux /usr/bin/om \
    && chmod +x /usr/bin/om

ENV GOPATH /go

RUN curl -fsSL "https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz" -o golang.tar.gz \
    && echo "1862f4c3d3907e59b04a757cfda0ea7aa9ef39274af99a784f5be843c80c6772 golang.tar.gz" | sha256sum -c - \
    && tar -C /usr/local -xzf golang.tar.gz \
    && rm golang.tar.gz \
    && mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

RUN curl -L -o cf.tgz "https://cli.run.pivotal.io/stable?release=linux64-binary&version=6.26.0&source=github-rel" \
    && tar -xzf cf.tgz \
    && rm cf.tgz \
    && mv cf /usr/bin/cf

ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

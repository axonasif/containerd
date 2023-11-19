FROM gitpod/workspace-base@sha256:8eb7d38a816ea82abd38562c136141a4dad56661483f67d8fbb1874bdf37d87f

# Add golang
# Source: https://github.com/gitpod-io/workspace-images/tree/f8ab1b8e6c288ac9b6c86bfc314f526376a3bca6/chunks/lang-go
COPY --from=gitpod/workspace-go@sha256:2e93468a7114e5ce5bde765deee1a72d70c87a42c90b32e4e6b314dde31abfcb / /
ENV GO_VERSION="1.21.3"
ENV GOPATH=$HOME/go-packages
ENV GOROOT=$HOME/go
ENV PATH=$GOROOT/bin:$GOPATH/bin:$PATH

RUN sudo add-apt-repository -y ppa:criu/ppa \
    && sudo install-packages \
    gperf \
    dmsetup \
    bc \
    software-properties-common \
    libseccomp-dev \
    xfsprogs \
    lsof \
    iptables \
    autoconf \
    automake \
    g++ \
    libtool \
    acl \
    criu

ARG onetime_cache_dir="/tmp/.workdir"
RUN mkdir -p "${onetime_cache_dir}"
COPY --chown=gitpod:gitpod . "${onetime_cache_dir}"

WORKDIR "${onetime_cache_dir}"

RUN script/setup/install-dev-tools \
    && sudo PATH=$PATH bash .devcontainer/setup.sh

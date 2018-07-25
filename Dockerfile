FROM debian:stretch-slim
LABEL maintainer="b00za@pm.me"

ARG PIVX_UID=51472
ENV PIVX_VERSION=3.1.0.2

RUN apt-get -qq update && \
    apt-get -yq install wget ca-certificates && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY fuzzbawls.gpg /root/.gnupg/trustedkeys.gpg

RUN wget -nv https://github.com/PIVX-Project/PIVX/releases/download/v$PIVX_VERSION/pivx-$PIVX_VERSION-x86_64-linux-gnu.tar.gz \
             https://github.com/PIVX-Project/PIVX/releases/download/v$PIVX_VERSION/SHA256SUMS.asc && \
    gpgv SHA256SUMS.asc && \
    sha256sum -c --ignore-missing SHA256SUMS.asc && \
    tar -C /opt -xvzf pivx-$PIVX_VERSION-x86_64-linux-gnu.tar.gz && \
    ln -sv pivx-3.1.0 /opt/pivx && \
    ln -sv /opt/pivx/bin/pivxd /usr/local/bin/pivxd && \
    ln -sv /opt/pivx/bin/pivx-cli /usr/local/bin/pivx-cli && \
    ln -sv /opt/pivx/bin/pivx-tx /usr/local/bin/pivx-tx && \
    rm -v /opt/pivx/bin/pivx-qt /opt/pivx/bin/test_pivx /opt/pivx/bin/test_pivx-qt \
          pivx-$PIVX_VERSION-x86_64-linux-gnu.tar.gz SHA256SUMS.asc && \
    useradd --uid $PIVX_UID --create-home --home-dir /pivx pivx && \
    mkdir -m 0750 /pivx/.pivx && \
    chown -R pivx:pivx /pivx

USER pivx

EXPOSE 51472
VOLUME ["/pivx/.pivx"]
WORKDIR /pivx

ENTRYPOINT ["/usr/local/bin/pivxd"]
CMD [ "-printtoconsole" ]


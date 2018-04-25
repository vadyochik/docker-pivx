FROM debian:stretch-slim
LABEL maintainer="b00za@pm.me"

ENV PIVX_VERSION=3.0.6

RUN apt-get -qq update && \
    apt-get -yq install wget ca-certificates && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    wget -nv https://github.com/PIVX-Project/PIVX/releases/download/v$PIVX_VERSION/pivx-$PIVX_VERSION-x86_64-linux-gnu.tar.gz -O - | tar -C /opt -xvz && \
    ln -sf pivx-$PIVX_VERSION /opt/pivx && \
    ln -sf /opt/pivx/bin/pivxd /usr/local/bin/pivxd && \
    ln -sf /opt/pivx/bin/pivx-cli /usr/local/bin/pivx-cli && \
    ln -sf /opt/pivx/bin/pivx-tx /usr/local/bin/pivx-tx && \
    useradd --system --create-home --home-dir /pivx pivx && \
    mkdir -m 0750 /pivx/.pivx && \
    echo "rpcuser=pivxrpc" > /pivx/.pivx/pivx.conf && \
    echo "rpcpassword=$(tr -dc a-zA-Z0-9 < /dev/urandom | head -c44)" >> /pivx/.pivx/pivx.conf && \
    chmod 400 /pivx/.pivx/pivx.conf && \
    chown -R pivx:pivx /pivx

USER pivx

EXPOSE 51472
VOLUME ["/pivx/.pivx"]
WORKDIR /pivx

ENTRYPOINT ["/usr/local/bin/pivxd"]
CMD [ "-printtoconsole" ]


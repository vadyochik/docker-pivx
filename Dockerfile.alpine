FROM alpine:3.8 AS builder
ARG PIVX_REPO=https://github.com/PIVX-Project/PIVX.git
ARG PIVX_VERSION=v3.1.1
ARG DB_VERSION=4.8.30.NC
RUN apk update && \
    apk add alpine-sdk curl file binutils autoconf automake \
            libtool boost-dev openssl-dev libevent-dev
# download barkeley DB sources
RUN curl -L http://download.oracle.com/berkeley-db/db-$DB_VERSION.tar.gz \
    | tar zxC ~
# build barkeley DB
RUN cd ~/db-$DB_VERSION/build_unix && \
    ../dist/configure \
      --prefix=/opt/db \
      --enable-cxx \
      --disable-shared \
      --with-pic && \
    make install
# download PIVX sources
RUN git clone ${PIVX_REPO} ~/PIVX
# build PIVX
RUN echo "Building PIVX from sources.." >&2 && \
    cd ~/PIVX && \
    git checkout ${PIVX_VERSION} && \
    ./autogen.sh && \
    ./configure LDFLAGS=-L/opt/db/lib CPPFLAGS=-I/opt/db/include --disable-tests && \
    make && \
    make install
RUN echo "PIVX binaries have been installed!" >&2 && \
    ls -la /usr/local/bin/ && \
    echo "Stripping the binaries..." >&2 && \
    strip /usr/local/bin/* && \
    echo "Stripping done!" >&2 && \
    ls -la /usr/local/bin/
#    echo "Running PIVX tests.." >&2 && \
#    /usr/local/bin/test_pivx

FROM alpine:3.8
ARG PIVX_UID=51472
ARG PIVX_USER=pivx
ARG PIVX_HOME=/pivx
ARG PIVX_CONFIG=default
COPY --from=builder /usr/local/bin/pivx* /usr/local/bin/
RUN apk --no-cache add boost boost-program_options libssl1.0 libevent && \
    adduser -u ${PIVX_UID} -h ${PIVX_HOME} -g "PIVX User" -D ${PIVX_USER} && \
    mkdir -m 0750 ${PIVX_HOME}/.pivx && \
    chown ${PIVX_USER}:${PIVX_USER} ${PIVX_HOME}/.pivx 

USER ${PIVX_USER}

EXPOSE 51472
VOLUME ["${PIVX_HOME}/.pivx"]
WORKDIR ${PIVX_HOME}

ENTRYPOINT ["/usr/local/bin/pivxd"]
CMD [ "-printtoconsole" ]

# syntax = docker/dockerfile:1

ARG DISTRO_NAME=bookworm
ARG RUBY_VERSION=3.1.4

FROM ruby:${RUBY_VERSION}-${DISTRO_NAME}

ARG BUNDLER_VERSION=2.3.11
ARG DISTRO_NAME=bookworm
ARG NODE_MAJOR=18
ARG PG_MAJOR=15
ARG YARN_VERSION=latest

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=tmpfs,target=/var/log \
    rm -f /etc/apt/apt.conf.d/docker-clean; \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/01keep-debs; \
    apt-get update -qq && \
    apt-get install -yq --no-install-recommends \
    build-essential \
    cmake \
    libclang-dev \
    postgresql-client-${PG_MAJOR}

RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | \
    gpg --dearmor -o /etc/apt/trusted.gpg.d/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/trusted.gpg.d/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x ${DISTRO_NAME} main" | \
    tee /etc/apt/sources.list.d/nodesource.list && \
    echo "deb-src [signed-by=/etc/apt/trusted.gpg.d/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x ${DISTRO_NAME} main" | \
    tee -a /etc/apt/sources.list.d/nodesource.list
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=tmpfs,target=/var/log \
    apt-get update -qq && \
    apt-get install -yq --no-install-recommends nodejs npm
RUN npm install -g yarn@${YARN_VERSION}

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

RUN gem install bundler:${BUNDLER_VERSION}

ENV BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_JOBS=4

WORKDIR /app

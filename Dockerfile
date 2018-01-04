# Dockerfile.build
FROM buildpack-deps:xenial

ENV DEBIAN_FRONTEND noninteractive

# Set the locale
RUN apt-get update && \
  apt-get install -y locales && \
  locale-gen en_GB.UTF-8

ENV LANG en_GB.UTF-8
ENV LANGUAGE en_GB:en
ENV LC_ALL en_GB.UTF-8

# install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
  apt-utils \
  curl \
  git \
  unzip \
  build-essential
  # unixodbc-dev \  # optional
  # xsltproc \      # optional
  # fop \           # optional
  # libxml2-utils   # optional

# RUN useradd -ms $(which bash) asdf

ENV PATH /root/.asdf/bin:/root/.asdf/shims:$PATH

#USER asdf

# ENV ERLANG_REPO_PKG_VERSION="1.0"
ENV ASDF_VERSION="0.4.1"
ENV ERLANG_VERSION="20.2"
ENV ELIXIR_VERSION="1.5.3"

# install asdf & erlang
RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v${ASDF_VERSION} && \
  asdf plugin-add erlang && \
  asdf install erlang ${ERLANG_VERSION} && \
  asdf global erlang ${ERLANG_VERSION} && \
  rm -rf  /tmp/*

# install elixir
RUN asdf plugin-add elixir && \
  asdf install elixir ${ELIXIR_VERSION} && \
  asdf global elixir ${ELIXIR_VERSION} && \
  rm -rf  /tmp/*

# Install Hex+Rebar
RUN mix local.hex --force && \
    mix local.rebar --force
WORKDIR /opt/app
ENV MIX_ENV=prod REPLACE_OS_VARS=true

# Cache elixir deps
COPY mix.exs mix.lock ./
RUN mix deps.get
COPY config ./config
RUN mix deps.compile

COPY . .
RUN mix release --env=prod

# Copy to export folder
RUN APP_NAME="dashwallet" && \
    RELEASE_DIR=`ls -d _build/prod/rel/$APP_NAME/releases/*/` && \
    mkdir /export && \
    cp "$RELEASE_DIR/$APP_NAME.tar.gz" /export
    # tar -xf "$RELEASE_DIR/$APP_NAME.tar.gz" -C /export


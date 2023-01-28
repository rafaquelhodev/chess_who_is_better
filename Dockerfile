FROM elixir:1.14-alpine

RUN apk add inotify-tools

WORKDIR /app

RUN mix local.hex --force && \
  mix local.rebar --force && \
  mix archive.install --force hex phx_new

RUN apk add --no-cache make g++ wget ca-certificates

ARG PV=15

# fetch and compile stockfish
RUN mkdir -p /root/tmp && \
	cd /root/tmp && \
	wget https://github.com/official-stockfish/Stockfish/archive/sf_${PV}.tar.gz && \
	tar xvf /root/tmp/sf_${PV}.tar.gz && \
	cd /root/tmp/Stockfish-sf_${PV}/src && \
	make build ARCH=x86-64-modern && \
	mv /root/tmp/Stockfish-sf_${PV}/src/stockfish /usr/local/bin/stockfish

# remove leftovers
RUN apk del --no-cache wget ca-certificates
RUN rm -rf /root/tmp

COPY mix.exs .
COPY mix.lock .

# copy the deps in dev environment for faster builds
COPY deps ./deps
RUN ["mix", "deps.get"]
RUN ["mix", "deps.compile"]

COPY assets ./assets
COPY config ./config
COPY lib ./lib
COPY priv ./priv
COPY test ./test

RUN ["mix", "compile"]

# compile deps in test environment for faster test runs when built
RUN export MIX_ENV=dev && mix deps.compile

CMD ["mix", "phx.server"]
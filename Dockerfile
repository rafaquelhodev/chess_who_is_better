FROM elixir:1.14-alpine

RUN apk add inotify-tools

WORKDIR /app

RUN mix local.hex --force && \
  mix local.rebar --force && \
  mix archive.install --force hex phx_new

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
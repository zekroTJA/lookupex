FROM elixir:alpine

WORKDIR /app

COPY lib lib
COPY config config
COPY mix.exs .
COPY mix.lock .

RUN mix local.hex --force \
    && mix local.rebar --force \
    && mix deps.get \
    && mix deps.compile

ENV BIND_ADDRESS="0.0.0.0:8080"

EXPOSE 8080

ENTRYPOINT ["mix", "run", "--no-halt"]
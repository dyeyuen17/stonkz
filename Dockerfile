FROM elixir:1.14.2

RUN apt-get update
RUN apt-get install --yes build-essential inotify-tools

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

WORKDIR /app
EXPOSE 4000
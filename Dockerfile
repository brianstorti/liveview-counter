FROM elixir:1.10

WORKDIR /app

COPY . /app

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install -y nodejs

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get --force

RUN npm install --prefix assets

CMD ["mix", "phx.server"]

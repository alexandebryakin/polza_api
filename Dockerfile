FROM ruby:3.1.2-slim

ENV PG_VERSION 14.5
RUN apt-get update -qq && apt-get install -qq --no-install-recommends \
    curl gnupg2 build-essential patch ruby-dev zlib1g-dev liblzma-dev libpq-dev git nano wget postgresql-client

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN wget https://dl.yarnpkg.com/debian/pubkey.gpg
RUN cat pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -qq --no-install-recommends \
    nodejs \
    yarn \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install -j 2

ENV PATH=/app/bin:$PATH

COPY . .

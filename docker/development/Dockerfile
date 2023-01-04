FROM ruby:3.1.2-slim

ENV PG_VERSION 14.5
RUN apt-get update -qq \
    && apt-get install -qq --no-install-recommends \
      curl \
      gnupg2 \
      build-essential \
      patch \
      ruby-dev \
      zlib1g-dev \
      liblzma-dev \
      libpq-dev \
      git \
      nano \
      wget \
      postgresql-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install -j 2

ENV PATH=/app/bin:$PATH

COPY . .

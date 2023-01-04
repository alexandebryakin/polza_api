##############################################################
# Base image used as a basis to build step and for final image
##############################################################
FROM ruby:3.1.2-slim as base

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update -qq && apt-get install -qq --no-install-recommends \
    curl \
    gnupg2 \
    unzip \
    libpq5 \
    zlib1g \
    liblzma5 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

ENV GEM_HOME=/usr/local/bundle
ENV BUNDLE_PATH=$GEM_HOME

ENV RAILS_ENV=production
ENV RACK_ENV=production

###############################
# Image with build dependencies
###############################
FROM base as dependencies

RUN apt-get update -qq && apt-get install -qq --no-install-recommends \
  build-essential \
  zlib1g-dev \
  liblzma-dev \
  libpq-dev \
  git \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ENV BUNDLE_JOBS=2
RUN bundle config set without 'development test' \
  && echo 'gem: --no-document' >> ~/.gemrc \
  && bundle config set deployment true

COPY Gemfile Gemfile.lock ./
RUN bundle install


########################
# Final deployable image
########################
FROM base as deploy
# Copy prebuilt gems
COPY --from=dependencies $BUNDLE_PATH $BUNDLE_PATH
# Copy app code
COPY . /app

# The default command that gets ran will be to start the Puma server.
RUN mkdir -p tmp/pids

# [NOTE]: entrypoint.sh runs migrations
COPY ./bin/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

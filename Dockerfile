FROM ruby:2.5.1
MAINTAINER dPI "info@depraktijkindex.nl"

# dependencies
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" \
      > /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive \
      apt-get install -y --no-install-recommends \
              postgresql-client \
              nodejs \
              yarn \
              rsync \
              locales \
    && rm -rf /var/lib/apt/lists/* \
    && echo en_US.UTF-8 UTF-8 > /etc/locale.gen \
    && locale-gen \
    && DEBIAN_FRONTEND=noninteractive \
      dpkg-reconfigure locales

# user/environment
ENV APP_HOME=/app BUNDLE_PATH=/bundle LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
RUN addgroup --disabled-password --gecos '' --gid 1000 rails \
    && adduser --disabled-password --gecos '' --uid 1000 --gid 1000 rails \
    && mkdir $APP_HOME $BUNDLE_PATH
USER 1000:1000
WORKDIR $APP_HOME
ENV PATH="${APP_HOME}/bin:${PATH}"

# ruby/rails
RUN echo 'gem: --no-document' >> ~/.gemrc \
    && gem install bundler \
    && bundle config --global path /bundle

COPY Gemfile* $APP_HOME/
RUN bundle install

COPY package.json yarn.lock $APP_HOME/
RUN yarn install

COPY . $APP_HOME
RUN chown rails:rails $APP_HOME $BUNDLE_PATH
CMD ["bin/rails", "server", "-p", "3000", "-b", "0.0.0.0"]

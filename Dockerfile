FROM ruby:3.0

ENV LANG C.UTF-8
ENV TZ Asia/Tokyo
ENV BUNDLER_VERSION 2.0.2

RUN wget -O - https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && \
    apt-get install -y nodejs postgresql-client yarn vim bash && \
    rm -rf /var/lib/apt/lists/*

ENV APP_ROOT /utakata

WORKDIR $APP_ROOT
ADD ./Gemfile $APP_ROOT/Gemfile
ADD ./Gemfile.lock $APP_ROOT/Gemfile.lock

RUN bundle install
RUN chsh -s /bin/bash
FROM ruby:4
WORKDIR /app
RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash -
RUN apt-get update -qq && \
  apt-get install -y --no-install-recommends nodejs && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

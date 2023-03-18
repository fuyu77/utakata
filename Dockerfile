FROM ruby:3
WORKDIR /app
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get update -qq && \
  apt-get install -y --no-install-recommends nodejs git && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*
RUN npm install -g yarn

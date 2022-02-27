FROM ruby:3.0.3
WORKDIR /app
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update -qq && apt-get install -y nodejs git
RUN npm install -g yarn

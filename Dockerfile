FROM ruby:2.5.0-alpine
MAINTAINER Scott Pierce <ddrscott@gmail.com>

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apk update && apk add nodejs build-base tzdata libxml2-dev libxslt-dev postgresql-dev

# Clean APK cache
RUN rm -rf /var/cache/apk/*

RUN mkdir /app
WORKDIR /app

COPY Gemfile ./Gemfile
COPY Gemfile.lock ./Gemfile.lock

RUN bundle install --jobs 20 --retry 5

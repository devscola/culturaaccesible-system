FROM ruby:2.4.0

RUN mkdir -p /opt/culturaaccesible
ADD . /opt/culturaaccesible
WORKDIR /opt/culturaaccesible

ENV SYSTEM_MODE development

RUN apt-get update
RUN gem install bundler
RUN bundle install

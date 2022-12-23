FROM ruby:3.1.2

USER root
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /webapp
WORKDIR /webapp
ADD Gemfile /webapp/Gemfile
ADD Gemfile.lock /webapp/Gemfile.lock
RUN bundle install
ADD . /webapp

FROM ruby:2
RUN apt-get update -qq && apt-get install -y build-essential libmysqlclient-dev nodejs
RUN mkdir /brain
WORKDIR /brain
ADD Gemfile /brain/Gemfile
ADD Gemfile.lock /brain/Gemfile.lock
RUN bundle install
ADD . /brain
ENV PATH "/brain/bin:${PATH}"

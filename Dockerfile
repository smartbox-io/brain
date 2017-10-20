FROM ruby:alpine
RUN apk add --update build-base mariadb-dev sqlite-dev nodejs tzdata && rm -rf /var/cache/apk/*
RUN mkdir /brain
WORKDIR /brain
ADD Gemfile /brain/Gemfile
ADD Gemfile.lock /brain/Gemfile.lock
RUN bundle install
ADD . /brain
ENV PATH "/brain/bin:${PATH}"

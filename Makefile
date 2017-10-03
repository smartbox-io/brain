.PHONY: all build spec brakeman

all: build spec brakeman

build:
	docker build -t brain .

run:
	docker run --rm -v `pwd`:/brain -it brain:latest bash

spec:
	docker run --rm -v `pwd`:/brain -it brain:latest bundle exec rspec

rubocop:
	docker run --rm -v `pwd`:/brain -it brain:latest bundle exec rubocop -D

brakeman:
	docker run --rm -v `pwd`:/brain -it brain:latest bundle exec brakeman -zAI

update:
	docker run --rm -v `pwd`:/brain -it brain:latest bundle update

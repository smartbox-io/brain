SPEC ?= spec

.PHONY: all build spec brakeman

all: build spec brakeman

build:
	docker build -t brain .

run:
	docker run --rm -v `pwd`:/brain -it brain:latest sh

routes:
	docker run --rm -v `pwd`:/brain -it brain:latest bundle exec rake routes

spec:
	docker run --rm -v `pwd`:/brain -it brain:latest bundle exec rspec $(SPEC)

models:
	docker run --rm -e COVERAGE=models -v `pwd`:/brain -it brain:latest bundle exec rspec spec/models

requests:
	docker run --rm -e COVERAGE=requests -v `pwd`:/brain -it brain:latest bundle exec rspec spec/requests

rubocop:
	docker run --rm -v `pwd`:/brain -it brain:latest bundle exec rubocop -D

brakeman:
	docker run --rm -v `pwd`:/brain -it brain:latest bundle exec brakeman -zAI

update:
	docker run --rm -v `pwd`:/brain -it brain:latest bundle update

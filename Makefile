.PHONY: all build spec brakeman

all: build spec brakeman

build:
	docker build -t brain .

spec:
	docker run --rm -v `pwd`:/brain -it brain:latest rspec

brakeman:
	docker run --rm -v `pwd`:/brain -it brain:latest brakeman -zA

update:
	docker run --rm -v `pwd`:/brain -it brain:latest bundle update

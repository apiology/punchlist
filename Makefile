.PHONY: spec

all:
	@bundle exec rake localtest

spec:
	@bundle exec rake spec

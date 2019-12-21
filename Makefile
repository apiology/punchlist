.PHONY: spec

all:
	@bundle exec rake localtest

spec:
	@bundle exec rake spec

quality:
	@bundle exec rake quality

rubocop:
	@bundle exec rake rubocop

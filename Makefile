.PHONY: spec feature

all:
	@bundle exec rake localtest

spec:
	@bundle exec rake spec

feature:
	@bundle exec rake feature

quality:
	@bundle exec rake quality

rubocop:
	@bundle exec rake rubocop

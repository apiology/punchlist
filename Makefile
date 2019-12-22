.PHONY: spec feature

# TODO: Read and adopt http://www.betterspecs.org/#guard
# TODO: Read and adopt https://relishapp.com/rspec/rspec-core/v/2-11/docs/example-groups/shared-examples
# TODO: Read up on https://jeffkreeftmeijer.com/fuubar-rspec-progress-bar-formatter/

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

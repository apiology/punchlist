require 'simplecov'
SimpleCov.start do
  # this dir used by TravisCI
  add_filter 'vendor'
end
SimpleCov.refuse_coverage_drop
require 'punchlist'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.order = 'random'
  config.alias_it_should_behave_like_to :has_behavior
  config.alias_it_should_behave_like_to :it_has_behavior, 'has behavior:'
end

def let_double(*doubles)
  doubles.each do |double_sym|
    let(double_sym) { double(double_sym.to_s) }
  end
end

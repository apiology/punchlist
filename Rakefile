# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'quality/rake/task'

task :pronto do
  formatter = '-f github_pr' if ENV.key? 'PRONTO_GITHUB_ACCESS_TOKEN'
  if ENV.key? 'TRAVIS_PULL_REQUEST'
    ENV['PRONTO_PULL_REQUEST_ID'] = ENV['TRAVIS_PULL_REQUEST']
  elsif ENV.key? 'CIRCLE_PULL_REQUEST'
    ENV['PRONTO_PULL_REQUEST_ID'] = ENV['CIRCLE_PULL_REQUEST'].split('/').last
  end
  puts "PRONTO_PULL_REQUEST_ID is #{ENV['PRONTO_PULL_REQUEST_ID']}"
  sh "pronto run #{formatter} -c origin/master --no-exit-code --unstaged "\
     '|| true'
  sh "pronto run #{formatter} -c origin/master --no-exit-code --staged || true"
  sh "pronto run #{formatter} -c origin/master --no-exit-code || true"
end

Quality::Rake::Task.new do |task|
  task.skip_tools = %w[reek shellcheck]
  task.output_dir = 'metrics'
  # Add 'xit ' to the standard list, finding disabled tests
  task.punchlist_regexp = 'XXX|TODO|FIXME|OPTIMIZE|HACK|REVIEW|LATER|FIXIT|xit '
end

task quality: %i[pronto]

desc 'Run specs'
RSpec::Core::RakeTask.new(:spec) do |task|
  task.pattern = 'spec/**/*_spec.rb'
  task.rspec_opts = '--format doc'
end

desc 'Run features'
RSpec::Core::RakeTask.new(:feature) do |task|
  task.pattern = 'feature/**/*_spec.rb'
  task.rspec_opts = '--format doc'
end

task :clear_metrics do |_t|
  ret =
    system('git checkout coverage/.last_run.json metrics/*_high_water_mark')
  raise unless ret
end

desc 'Default: Run specs and check quality.'
task localtest: %i[clear_metrics spec feature quality]
task test: %i[spec feature]
task default: [:localtest]

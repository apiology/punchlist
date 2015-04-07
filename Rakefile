require 'rspec/core/rake_task'
require 'quality/rake/task'

Quality::Rake::Task.new do |task|
  task.skip_tools = ['reek']
  task.output_dir = 'metrics'
end

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
  fail unless ret
end

desc 'Default: Run specs and check quality.'
task localtest: [:clear_metrics, :spec, :feature, :quality]
task default: [:localtest]

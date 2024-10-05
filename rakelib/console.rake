# frozen_string_literal: true

desc 'Load up punchlist in pry'
task :console do |_t|
  exec 'pry -I lib -r punchlist'
end

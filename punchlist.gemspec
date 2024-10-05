# coding: ascii
# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'punchlist/version'

Gem::Specification.new do |spec|
  spec.name          = 'punchlist'
  spec.version       = Punchlist::VERSION
  spec.authors       = ["Vince Broz"]
  spec.email         = ['vince@broz.cc']
  spec.summary       = "Counts the number of 'todo' comments in your code"
  spec.homepage      = 'https://github.com/apiology/punchlist'
  spec.license       = 'MIT license'
  spec.required_ruby_version = '>= 3.0'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency('source_finder', ['>=2'])

  spec.metadata = {
    'rubygems_mfa_required' => 'true',
  }
end

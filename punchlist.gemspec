# ; -*-Ruby-*-
# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.join(File.dirname(__FILE__), 'lib')
require 'punchlist/version'

Gem::Specification.new do |s|
  s.name = 'punchlist'
  s.version = Punchlist::VERSION

  s.authors = ['Vince Broz']
  s.description =
    "punchlist lists your annotation comments--things like 'TODO/FIXME/HACK'"
  s.email = ['vince@broz.cc']
  s.executables = ['punchlist']
  # s.extra_rdoc_files = ["CHANGELOG", "License.txt"]
  s.license = 'MIT'
  s.files = Dir['License.txt', 'README.md',
                'Rakefile',
                'bin/punchlist',
                '{lib}/**/*',
                'punchlist.gemspec'] & `git ls-files -z`.split("\0")
  # s.rdoc_options = ["--main", "README.md"]
  s.require_paths = ['lib']
  s.homepage = 'http://github.com/apiology/punchlist'
  # s.rubyforge_project = %q{punchlist}
  s.rubygems_version = '1.3.6'
  s.summary = 'Finds largest source files in a project'

  s.add_dependency('source_finder', ['>=2'])

  s.add_development_dependency('bundler')
  s.add_development_dependency('rake')
  s.add_development_dependency('quality', ['>=16'])
  s.add_development_dependency('rspec')
  s.add_development_dependency('simplecov')
end

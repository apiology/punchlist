# frozen_string_literal: true

require_relative 'feature_helper'
require 'punchlist'

describe Punchlist do
  # "pis" are "punchlist items"

  %w[mixed_types_of_source_files
     one_source_file_with_cis
     no_files
     source_file_with_no_items
     non_source_file_with_pis].each do |type|
    it "handles #{type} case" do
      expect(exec_io("cd feature/samples/#{type} &&" \
                     'RUBYLIB=`pwd`/../../lib:"$RUBYLIB" punchlist'))
        .to eq(IO.read("feature/expected/#{type}_results.txt"))
    end
  end

  %w[scala_file_to_be_ignored].each do |type|
    it "handles #{type} case with a special glob" do
      expect(exec_io("cd feature/samples/#{type} &&" \
                     'RUBYLIB=`pwd`/../../lib:"$RUBYLIB" ' \
                     "punchlist --glob '{app,lib,test,spec,feature}/**/*." \
                     "{rb,swift,cpp,c,java,py}'"))
        .to eq(IO.read("feature/expected/#{type}_results.txt"))
    end
  end

  let(:expected_usage) do
    "Usage: punchlist [options]\n"\
    '    -g, --glob glob here             ' \
    'Which files to parse - default is ' \
    '{Dockerfile,Rakefile,{*,.*}.{c,clj,cljs,cpp,gemspec,groovy,html,java,' \
    'js,json,py,rake,rb,scala,sh,swift,yml},{app,config,db,feature,lib,spec,' \
    'src,test,tests,vars,www}/**/{*,.*}.{c,clj,cljs,cpp,gemspec,groovy,html,' \
    'java,js,json,py,rake,rb,scala,sh,swift,yml}}' \
    "\n" \
    '    -e, --exclude-glob glob here     ' \
    "Files to exclude - default is none\n" \
    '    -r, --regexp r                   ' \
    'Regexp to trigger upon - default is ' \
    "XXX|TODO|FIXME|OPTIMIZE|HACK|REVIEW|LATER|FIXIT\n"
  end

  it 'starts up with short help argument' do
    expect(exec_io('punchlist -h'))
      .to eq(expected_usage)
  end

  it 'starts up with long help argument' do
    expect(exec_io('punchlist --help'))
      .to eq(expected_usage)
  end

  it 'starts up with invalid argument' do
    expect(exec_io('punchlist --blah'))
      .to match(/invalid option/)
  end

  xit 'handles passing in different annotation comments'
end

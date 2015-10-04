require_relative 'feature_helper'

describe Punchlist do
  # "pis" are "punchlist items"

  %w(mixed_types_of_source_files
     one_source_file_with_cis
     no_files
     source_file_with_no_items
     non_source_file_with_pis).each do |type|
    it "handles #{type} case" do
      expect(exec_io "cd feature/samples/#{type} &&" \
                     'RUBYLIB=`pwd`/../../lib:"$RUBYLIB" punchlist')
        .to eq(IO.read("feature/expected/#{type}_results.txt"))
    end
  end

  %w(scala_file_to_be_ignored).each do |type|
    it "handles #{type} case with a special glob" do
      expect(exec_io "cd feature/samples/#{type} &&" \
                     'RUBYLIB=`pwd`/../../lib:"$RUBYLIB" ' \
                     "punchlist --glob '{app,lib,test,spec,feature}/**/*." \
                     "{rb,swift,cpp,c,java,py}'")
        .to eq(IO.read("feature/expected/#{type}_results.txt"))
    end
  end

  EXPECTED_USAGE =
    "Usage: punchlist [options]\n"\
    '    -g, --glob glob here             ' \
    'Which files to parse - default is ' \
    '{Rakefile,Dockerfile,{*,.*}.{rb,rake,gemspec,swift,cpp,c,java,py,clj,' \
    'cljs,scala,js,yml,sh,json},{src,app,config,db,lib,test,spec,feature}/**/' \
    '{*,.*}.{rb,rake,gemspec,swift,cpp,c,java,py,clj,cljs,scala,js,yml,' \
    'sh,json}}' \
    "\n" \
    '    -e, --exclude-glob glob here     ' \
    "Files to exclude - default is none\n" \
    '    -r, --regexp r                   ' \
    'Regexp to trigger upon - default is ' \
    "XXX|TODO|FIXME|OPTIMIZE|HACK|REVIEW|LATER|FIXIT\n"

  it 'starts up with short help argument' do
    expect(exec_io 'punchlist -h')
      .to eq(EXPECTED_USAGE)
  end

  it 'starts up with long help argument' do
    expect(exec_io 'punchlist --help')
      .to eq(EXPECTED_USAGE)
  end

  it 'starts up with invalid argument' do
    expect(exec_io 'punchlist --blah')
      .to match(/invalid option/)
  end

  # TODO: handle passing in different annotation comments
end

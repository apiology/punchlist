require_relative 'feature_helper'

describe 'bigfiles' do
  # "pis" are "punchlist items"
  #
  # TODO: mixed_set
  # TODO: more_than_once_source_file
  # TODO: three_files
  # TODO: four_files
  # TODO: swift_and_ruby_files
  # TODO: swift_zorb_and_ruby_files

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
    "USAGE: punchlist\n" \
    '--glob blah blah blah'

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
      .to eq(EXPECTED_USAGE)
  end

  # TODO: handle passing in different annotation comments
end

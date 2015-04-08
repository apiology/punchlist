require_relative 'feature_helper'

describe 'bigfiles' do
  it 'starts up with no arguments' do
    expect(exec_io 'punchlist -h')
      .to eq("USAGE: punchlist\n")
  end

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
end

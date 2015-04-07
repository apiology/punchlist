require_relative 'feature_helper'

describe 'bigfiles' do
  it 'starts up with no arguments' do
    expect(exec_io 'punchlist -h')
      .to eq("USAGE: punchlist\n")
  end

  # three_files one_file two_files some_nonsource_files many_files
  # zero_byte_file
  %w(no_files three_files four_files swift_and_ruby_files
     swift_zorb_and_ruby_files).each do |type|
    xit "handles #{type} case" do
      expect(exec_io "cd feature/samples/#{type} &&" \
                     'RUBYLIB=`pwd`/../../lib:"$RUBYLIB" bigfiles ' \
                     "--glob '*.{rb,swift,zorb}'")
        .to eq(IO.read("feature/expected/#{type}_results.txt"))
    end
  end
end

# frozen_string_literal: true

require 'spec_helper'
require 'punchlist'
require 'punchlist/offense'

describe Punchlist::Inspector do
  let(:file_opener) do
    class_double(File, 'file_opener')
  end
  let(:punchlist_line_regexp) { Regexp.new('MYPL|SOMEOTHERPL') }
  let(:filename) { instance_double(String, 'filename') }
  let(:inspector) do
    described_class.new(punchlist_line_regexp,
                        filename,
                        file_opener: file_opener)
  end
  let(:file) { instance_double(IO, 'file') }

  describe '#run' do
    subject(:inspector_run_results) { inspector.run }

    before do
      allow(file_opener).to(receive(:open)).with(filename, 'r')
                        .and_yield(StringIO.new(contents))
    end

    context 'with no lines in source file' do
      let(:contents) { '' }

      it { is_expected.to eq [] }
    end

    context 'with one irrelevant line in line in source file' do
      let(:contents) { 'foo' }

      it { is_expected.to eq [] }
    end

    context 'with one relevant line in source file' do
      let(:contents) { 'MYPL: Add some code here' }

      it { is_expected.to eq [Punchlist::Offense.new(filename, 1, contents)] }
    end

    context 'with two relevant lines in source file' do
      let(:contents_arr) do
        [
          'MYPL: Add some code here',
          'SOMEOTHERPL: Something else',
        ]
      end
      let(:contents) { contents_arr.join("\n") }

      it 'returns one lines' do
        expect(inspector_run_results).to eq [
          Punchlist::Offense.new(filename, 1, contents_arr[0]),
          Punchlist::Offense.new(filename, 2, contents_arr[1]),
        ]
      end
    end
  end
end

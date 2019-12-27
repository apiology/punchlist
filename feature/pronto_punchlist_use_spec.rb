# frozen_string_literal: true

require 'spec_helper'
require 'punchlist'
require 'punchlist/offense'

# Example use from https://github.com/apiology/pronto-punchlist

describe Punchlist do
  subject(:offenses) { ::Punchlist::Inspector.new(punchlist_line_regexp, path).run }

  let(:punchlist_line_regexp) do
    Regexp.new(::Punchlist::Config.default_punchlist_line_regexp_string)
  end
  let(:path) { 'feature/samples/mixed_types_of_source_files/lib/bar.scala' }

  it 'stays compatible with use by pronto-spec' do
    expect(offenses.length).to eq(1)
    offenses.each do |offense|
      expect(offense.filename).to eq(path)
      expect(offense.line_num).to eq(1)
    end
  end
end

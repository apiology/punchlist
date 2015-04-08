# -*- coding: utf-8 -*-
require 'spec_helper'
require 'punchlist'

describe Punchlist::Punchlist do
  let_double :outputter, :globber
  subject(:punchlist) do
    Punchlist::Punchlist.new(args,
                             outputter: outputter,
                             globber: globber)
  end

  context 'with help argument' do
    subject(:args) { ['-h'] }
    before(:each) do
      expect(outputter).to receive(:puts).with("USAGE: punchlist\n")
    end

    it 'gives' do
      punchlist.run
    end
  end
  context 'with real arguments' do
    before(:each) do
      expect(globber).to(receive(:glob))
        .with('{app,lib,test,spec,feature}/**/*.{rb,swift,cpp,c,java,py}')
        .and_return(files_found)
    end

    context 'with no arguments' do
      subject(:args) { [] }
      context 'and no files found' do
        subject(:files_found) { [] }
        it 'runs' do
          punchlist.run
        end
      end

      context 'and one source file found' do
        before(:each) do
          expect(outputter).to receive(:puts).with(expected_output)
        end

        subject(:expected_output) { "foo.rb:3: puts 'foo' # XXX change to bar" }
        subject(:files_found) { ['foo.rb'] }
        it 'runs' do
          punchlist.run
        end
      end
    end
  end
end

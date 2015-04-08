# -*- coding: utf-8 -*-
require 'spec_helper'
require 'punchlist'

describe Punchlist::Punchlist do
  let_double :outputter, :globber, :file_opener
  subject(:punchlist) do
    Punchlist::Punchlist.new(args,
                             outputter: outputter,
                             globber: globber,
                             file_opener: file_opener)
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
        .with('{app,lib,test,spec,feature}/**/' \
              '*.{rb,swift,scala,js,cpp,c,java,py}')
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

      context 'and we found' do
        before(:each) do
          expect(outputter).to receive(:puts).with(expected_output)
          file_contents.each do |filename, contents|
            expect(file_opener).to(receive(:open)).with(filename, 'r')
              .and_yield(StringIO.new(contents))
          end
        end

        context 'a ruby file' do
          subject(:expected_output) do
            "foo.rb:3: puts 'foo' # XXX change to bar\n"
          end
          subject(:files_found) { ['foo.rb'] }
          subject(:file_contents) do
            {
              'foo.rb' => "#\n#\n" \
                          "puts 'foo' # XXX change to bar\n"
            }
          end
          it 'runs' do
            punchlist.run
          end
        end

        context 'a scala file' do
          subject(:expected_output) do
            "bar.scala:5: println('zing') # XXX change to foo\n"
          end
          subject(:files_found) { ['bar.scala'] }
          subject(:file_contents) do
            {
              'bar.scala' => "#\n#\n#\n#\n" \
                             "println('zing') # XXX change to foo\n"
            }
          end
          it 'runs' do
            punchlist.run
          end
        end
      end
    end
  end
end

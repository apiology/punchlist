# -*- coding: utf-8 -*-
require 'spec_helper'
require 'punchlist'

describe Punchlist::Punchlist do
  let_double :outputter, :globber, :file_opener, :exiter
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
    subject(:files_found) { file_contents.keys }
    subject(:expected_glob) do
      '{app,lib,test,spec,feature}/**/' \
      '*.{rb,swift,scala,js,cpp,c,java,py}'
    end
    before(:each) do
      expect(globber).to(receive(:glob))
        .with(expected_glob)
        .and_return(files_found)
      if files_found.count > 0
        expect(outputter).to receive(:puts).with(expected_output)
      end
      file_contents.each do |filename, contents|
        expect(file_opener).to(receive(:open)).with(filename, 'r')
          .and_yield(StringIO.new(contents))
      end
    end

    context 'with no arguments' do
      subject(:args) { [] }
      context 'and no files found' do
        subject(:file_contents) do
          {}
        end
        it 'runs' do
          punchlist.run
        end
      end

      context 'and we found' do
        context 'a ruby file' do
          subject(:expected_output) do
            "foo.rb:3: puts 'foo' # XXX change to bar\n"
          end
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

    context 'with glob argument excluding scala' do
      context 'and we found' do
        context 'a ruby and scala file' do
          subject(:expected_output) do
            "foo.rb:3: puts 'foo' # XXX change to bar\n"
          end
          subject(:expected_glob) do
            '**/*.rb'
          end
          subject(:file_contents) do
            {
              'foo.rb' => "#\n#\n" \
                          "puts 'foo' # XXX change to bar\n"
            }
          end
          subject(:args) { ['--glob', '**/*.rb'] }

          it 'runs' do
            punchlist.run
          end
        end
      end
    end
  end
end

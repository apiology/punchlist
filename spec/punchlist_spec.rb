# -*- coding: utf-8 -*-
require 'spec_helper'
require 'punchlist'

describe Punchlist::Punchlist do
  let_double :outputter, :globber, :file_opener, :exiter, :source_file_globber
  subject(:punchlist) do
    Punchlist::Punchlist.new(args,
                             outputter: outputter,
                             file_opener: file_opener,
                             source_file_globber: source_file_globber)
  end
  subject(:args) { [] }

  context 'with real arguments' do
    subject(:files_found) { file_contents.keys }
    subject(:expected_glob) do
      '{app,lib,test,spec,feature}/**/' \
      '*.{rb,swift,scala,js,cpp,c,java,py}'
    end
    subject(:expected_exclude_glob) do
      nil
    end

    before(:each) do
      allow(source_file_globber).to(receive(:source_files_glob=))
        .with(expected_glob)
      allow(source_file_globber).to(receive(:source_files_exclude_glob=))
        .with(expected_exclude_glob)
      allow(source_file_globber).to(receive(:source_files))
        .and_return(files_found)
      expect(outputter).to receive(:print).with(expected_output)
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
        subject(:expected_output) { '' }
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

        context 'a scala file with no entries' do
          subject(:expected_output) do
            ''
          end
          subject(:file_contents) do
            {
              'bar.scala' => "#\n#\n#\n#\n" \
                             "println('zing') #  change to foo\n",
              'foo.rb' => '',
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

    context 'with regexp argument adding something' do
      context 'and we found' do
        context 'a ruby and scala file' do
          subject(:expected_output) do
            "foo.rb:3: puts 'foo' # FUTURE change to bar\n"
          end
          subject(:expected_glob) do
            '**/*.rb'
          end
          subject(:file_contents) do
            {
              'foo.rb' => "#\n#\n" \
                          "puts 'foo' # FUTURE change to bar\n"
            }
          end
          subject(:args) { ['--glob', '**/*.rb', '--regexp', 'FUTURE'] }

          it 'runs' do
            punchlist.run
          end
        end
      end
    end

    context 'with regexp argument excluding something' do
      context 'and we found' do
        context 'a ruby and scala file' do
          subject(:expected_output) do
            "foo.rb:3: puts 'foo' # FUTURE change to bar\n"
          end
          subject(:expected_glob) do
            '**/*.rb'
          end
          subject(:expected_exclude_glob) do
            'lib/foo/baz.rb'
          end
          subject(:file_contents) do
            {
              'foo.rb' => "#\n#\n" \
                          "puts 'foo' # FUTURE change to bar\n"
            }
          end

          subject(:args) do
            ['--glob', '**/*.rb',
             '--regexp', 'FUTURE',
             '--exclude-glob', 'lib/foo/baz.rb']
          end

          it 'runs' do
            punchlist.run
          end
        end
      end
    end
  end
end

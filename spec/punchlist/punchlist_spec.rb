# frozen_string_literal: true

require 'spec_helper'
require 'punchlist'

describe Punchlist::Punchlist do
  let_double :outputter, :globber, :file_opener, :exiter, :source_file_globber
  let(:punchlist) do
    described_class.new(args,
                        outputter: outputter,
                        file_opener: file_opener,
                        source_file_globber: source_file_globber)
  end
  let(:args) { [] }

  context 'with real arguments' do
    let(:files_found) { file_contents.keys }
    let(:expected_glob) do
      '{app,lib,test,spec,feature}/**/' \
      '*.{rb,swift,scala,js,cpp,c,java,py}'
    end
    let(:expected_exclude_glob) { nil }

    def expect_globs_assigned
      allow(source_file_globber).to(receive(:source_files_glob=))
                                .with(expected_glob)
      allow(source_file_globber).to(receive(:source_files_exclude_glob=))
                                .with(expected_exclude_glob)
    end
    before do
      expect_globs_assigned
      allow(source_file_globber).to(receive(:source_files_arr))
                                .and_return(files_found)
      allow(outputter).to receive(:print).with(expected_output)
      file_contents.each do |filename, contents|
        expect(file_opener).to(receive(:open)).with(filename, 'r')
                           .and_yield(StringIO.new(contents))
      end
    end

    context 'with no arguments' do
      let(:args) { [] }

      context 'with no files found' do
        let(:file_contents) do
          {}
        end
        let(:expected_output) { '' }

        it 'runs' do
          expect(outputter).to receive(:print).with(expected_output)
          punchlist.run
        end
      end

      context 'with a file' do
        context 'with ruby code inside' do
          let(:expected_output) do
            "foo.rb:3: puts 'foo' # XXX change to bar\n"
          end
          let(:file_contents) do
            {
              'foo.rb' => "#\n#\n" \
                          "puts 'foo' # XXX change to bar\n",
            }
          end

          it 'runs' do
            expect(outputter).to receive(:print).with(expected_output)
            punchlist.run
          end
        end

        context 'with scala code inside' do
          let(:expected_output) do
            "bar.scala:5: println('zing') # XXX change to foo\n"
          end
          let(:file_contents) do
            {
              'bar.scala' => "#\n#\n#\n#\n" \
                             "println('zing') # XXX change to foo\n",
            }
          end

          it 'runs' do
            punchlist.run
          end
        end

        context 'with a scala code with no annotation comments' do
          let(:expected_output) do
            ''
          end
          let(:file_contents) do
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
      context 'with a ruby and scala file' do
        let(:expected_output) do
          "foo.rb:3: puts 'foo' # XXX change to bar\n"
        end
        let(:expected_glob) do
          '**/*.rb'
        end
        let(:file_contents) do
          {
            'foo.rb' => "#\n#\n" \
                        "puts 'foo' # XXX change to bar\n",
          }
        end
        let(:args) { ['--glob', '**/*.rb'] }

        it 'runs' do
          punchlist.run
        end
      end
    end

    context 'with regexp argument adding something' do
      context 'with a ruby and scala file' do
        let(:expected_output) do
          "foo.rb:3: puts 'foo' # FUTURE change to bar\n"
        end
        let(:expected_glob) { '**/*.rb' }
        let(:file_contents) do
          {
            'foo.rb' => "#\n#\n" \
                        "puts 'foo' # FUTURE change to bar\n",
          }
        end

        context 'with no exclusions' do
          let(:args) { ['--glob', '**/*.rb', '--regexp', 'FUTURE'] }

          it('runs') { punchlist.run }
        end

        context 'with exclusions' do
          let(:args) do
            ['--glob', '**/*.rb', '--regexp', 'FUTURE',
             '--exclude-glob', 'lib/foo/baz.rb']
          end
          let(:expected_exclude_glob) { 'lib/foo/baz.rb' }

          it('runs') { punchlist.run }
        end
      end
    end
  end
end

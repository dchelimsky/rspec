require File.dirname(__FILE__) + '/../../test_helper'
require 'spec/tool/command_line'
require 'stringio'

module Spec
  module Tool
    class CommandLineTest < Test::Unit::TestCase
      def test_writes_translated_file
        translator = Api::Mock.new "translator"
        filesystem = Api::Mock.new "filesystem"
        filesystem.should.receive(:write_translation).with "./test/spec/tool/test_unit_translator_test.rb", "spec/test_unit_translator_test.rb"
        filesystem.should.receive(:write_translation).with "./test/spec/tool/test_unit_api_test.rb",        "spec/test_unit_api_test.rb"
        filesystem.should.receive(:write_translation).with "./test/spec/tool/test_unit_api_spec.rb",        "spec/test_unit_api_spec.rb"
        filesystem.should.receive(:write_translation).with "./test/spec/tool/command_line_test.rb",         "spec/command_line_test.rb"

        cl = CommandLine.new(filesystem)
        out = StringIO.new
        cl.run(File.dirname(__FILE__), "spec", out)
      end
    end
  end
end
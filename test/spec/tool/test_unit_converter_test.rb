require File.dirname(__FILE__) + '/../../test_helper'
require 'spec/tool/test_unit_converter'
require 'tempfile'

module Spec
  module Tool
    class TestUnitConverterTest < Test::Unit::TestCase
      def test_should_translate_test_classes_to_contexts
        c = TestUnitConverter.new
        translated = c.translate(File.dirname(__FILE__) + '/very_complex_test.rb')
        expected_path = File.dirname(__FILE__) + '/very_complex_spec.rb'
        expected = File.open(expected_path).read

        translated_tmp = Tempfile.open("translated")
        translated_tmp.write(translated)
        translated_tmp.flush
        diff = `diff -u #{expected_path} #{translated_tmp.path}`
        if diff.strip != ""
          fail("Conversion didn't match expectation. Diff:\n#{diff}")
        end
      end
    end
  end
end
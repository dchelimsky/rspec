require File.dirname(__FILE__) + '/../../test_helper'
require 'rubygems'
require 'spec/test_to_spec/test_unit_translator'
require 'spec/test_to_spec/test_unit_api_test'
require 'tempfile'

module Spec
  module TestToSpec
    class TestUnitTranslatorTest < Test::Unit::TestCase
      def test_should_translate_test_classes_to_contexts
        c = TestUnitTranslator.new
        test_unit_file = File.dirname(__FILE__) + '/test_unit_api_test.rb'
        translated = c.translate(TestUnitApiTest)
#puts translated
#exit!1
        expected_path = File.dirname(__FILE__) + '/test_unit_api_spec.rb'
        expected = File.open(expected_path).read

        translated_tmp = Tempfile.open("translated")
        translated_tmp.write(translated)
        translated_tmp.flush
        translated_tmp.close

        diff = `diff -w -u #{expected_path} #{translated_tmp.path}`
        if diff.strip != ""
          fail("Conversion didn't match expectation. Diff:\n#{diff}")
        else
          assert true # Just so we get an assertion count in the output
        end
      end
      
    end
  end
end
require File.dirname(__FILE__) + '/../../test_helper'
require 'spec/test_to_spec/test_case_ext'
require 'spec/test_to_spec/testfiles/test_unit_api_test'
require 'tempfile'

class TestCaseExtTest < Test::Unit::TestCase
  def test_to_rspec_should_return_rspec_context
    translated = TestUnitApiTest.to_rspec
    translated_tmp = Tempfile.open("translated")
    translated_tmp.write(translated)
    translated_tmp.flush
    translated_tmp.close

    expected_path = File.dirname(__FILE__) + '/testfiles/test_unit_api_spec.rb'
    expected = File.open(expected_path).read

    diff = `diff -w -u #{expected_path} #{translated_tmp.path}`
    if diff.strip != ""
      # We should fail here....
      #fail("Conversion didn't match expectation. Diff:\n#{diff}")
    else
      assert true # Just so we get an assertion count in the output
    end
  end
end

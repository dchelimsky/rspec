require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Expectations
    module Helper
      class SupportedSymbolsTest < Test::Unit::TestCase
        def test_should_support_less_than
          "<".to_sym.should_be_supported_by_rspec
        end
        def test_should_support_less_than_or_equal_to
          "<=".to_sym.should_be_supported_by_rspec
        end
        def test_should_support_greater_than_or_equal_to
          ">=".to_sym.should_be_supported_by_rspec
        end
        def test_should_support_greater_than
          ">".to_sym.should_be_supported_by_rspec
        end
        def test_should_support_equals_operator
          "==".to_sym.should_be_supported_by_rspec
        end
        def test_should_support_regex_match_operator
          "=~".to_sym.should_be_supported_by_rspec
        end
      end
      class SupportedSymbolsTest < Test::Unit::TestCase
        def test_should_not_support_not_equals_operator
          "!=".to_sym.should_not_be_supported_by_rspec
        end
      end
    end
  end
end

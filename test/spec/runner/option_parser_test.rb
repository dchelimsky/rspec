require File.dirname(__FILE__) + '/../../test_helper'
require 'stringio'

module Spec
  module Runner
    class OptionParserTest < Test::Unit::TestCase

      def setup
        @err = StringIO.new
      end

      def test_verbose_should_be_true_by_default
        options = OptionParser.parse([], @err)
        assert(!options.verbose)
      end

      def test_out_should_be_stdout_by_default
        options = OptionParser.parse([], @err)
        assert_equal(STDOUT, options.out)
      end
      
      def test_verbose_should_be_settable_with_v
        options = OptionParser.parse(["-v"], @err)
        assert(options.verbose)
      end
      
      def test_verbose_should_be_settable_with_verbose
        options = OptionParser.parse(["--verbose"], @err)
        assert(options.verbose)
      end
      
      def test_doc_should_be_false_by_default
        options = OptionParser.parse([], @err)
        assert(!options.doc)
      end
      
      def test_doc_should_be_settable_with_d
        options = OptionParser.parse(["-d"], @err)
        assert(options.doc)
      end
      
      def test_out_should_be_settable_with_o
        options = OptionParser.parse(["-o","test.txt"], @err)
        assert_equal("test.txt", options.out)
      end
      
      def test_out_should_be_settable_with_of
        options = OptionParser.parse(["--of","test.txt"], @err)
        assert_equal("test.txt", options.out)
      end
      
      def test_should_print_usage_if_no_dir_specified
        options = OptionParser.parse([], @err)
        assert_match(/Usage: spec/, @err.string)
      end
    end
  end
end

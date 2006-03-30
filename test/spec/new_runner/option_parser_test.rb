require File.dirname(__FILE__) + '/../../test_helper'
require 'stringio'

module Spec
  module Runner
    class OptionParserTest < Test::Unit::TestCase

      def test_verbose_should_be_true_by_default
        options = OptionParser.parse([])
        assert(!options.verbose)
      end

      def test_out_should_be_stdout_by_default
        options = OptionParser.parse([])
        assert_equal(STDOUT, options.out)
      end
      
      def test_verbose_should_be_settable_with_v
        options = OptionParser.parse(["-v"])
        assert(options.verbose)
      end
      
      def test_verbose_should_be_settable_with_verbose
        options = OptionParser.parse(["--verbose"])
        assert(options.verbose)
      end
      
      def test_doc_should_be_false_by_default
        options = OptionParser.parse([])
        assert(!options.doc)
      end
      
      def test_doc_should_be_settable_with_d
        options = OptionParser.parse(["-d"])
        assert(options.doc)
      end
      
      def test_out_should_be_settable_with_o
        options = OptionParser.parse(["-o","test.txt"])
        assert_equal(File.exists?("text.txt"), options.verbose)
        File.delete("test.txt")
      end
      
      def test_out_should_be_settable_with_of
        options = OptionParser.parse(["--of","test.txt"])
        assert_equal(File.exists?("text.txt"), options.verbose)
        File.delete("test.txt")
      end
      
    end
  end
end

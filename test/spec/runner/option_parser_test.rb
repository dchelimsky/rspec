require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Runner
    class OptionParserTest < Test::Unit::TestCase

      def setup
        @out = StringIO.new
        @err = StringIO.new
      end

      def test_should_print_version_to_stdout
        options = OptionParser.parse(["--version"], false, @err, @out)
        @out.rewind
        assert_match(/RSpec-\d+\.\d+\.\d+ - BDD for Ruby\nhttp:\/\/rspec.rubyforge.org\/\n/n, @out.read)
      end

      def test_should_print_help_to_stdout
        options = OptionParser.parse(["--help"], false, @err, @out)
        @out.rewind
        assert_match(/Usage: spec \[options\] \(FILE\|DIRECTORY\)\+/n, @out.read)
      end
      
      def test_verbose_should_be_true_by_default
        options = OptionParser.parse([], false, @err, @out)
        assert(!options.verbose)
      end

      def test_out_should_be_stdout_by_default
        options = OptionParser.parse([], false, @err)
        assert_equal(STDOUT, options.out)
      end
      
      def test_verbose_should_be_settable_with_v
        options = OptionParser.parse(["-v"], false, @err, @out)
        assert(options.verbose)
      end
      
      def test_verbose_should_be_settable_with_verbose
        options = OptionParser.parse(["--verbose"], false, @err, @out)
        assert(options.verbose)
      end
      
      def test_doc_should_be_false_by_default
        options = OptionParser.parse([], false, @err, @out)
        assert(!options.doc)
      end
      
      def test_doc_should_be_settable_with_d
        options = OptionParser.parse(["-d"], false, @err, @out)
        assert(options.doc)
      end
      
      def test_out_should_be_settable_with_o
        options = OptionParser.parse(["-o","test.txt"], false, @err, @out)
        assert_equal("test.txt", options.out)
      end
      
      def test_out_should_be_settable_with_of
        options = OptionParser.parse(["--of","test.txt"], false, @err, @out)
        assert_equal("test.txt", options.out)
      end

      def test_should_print_usage_to_err_if_no_dir_specified
        options = OptionParser.parse([], false, @err, @out)
        assert_match(/Usage: spec/, @err.string)
      end
      
      def test_out_should_be_stringio_if_set_to_stringio
        options = OptionParser.parse(["-o","stringio"], false, @err, @out)
        options.out.should.be.an.instance.of StringIO
      end
      
      def test_backtrace_tweaker_should_be_quiet_by_default
        options = OptionParser.parse([], false, @err, @out)
        assert options.backtrace_tweaker.instance_of?(QuietBacktraceTweaker)
      end
      
      def test_backtrace_tweaker_should_be_noisy_with_b
        options = OptionParser.parse(["-b"], false, @err, @out)
        assert options.backtrace_tweaker.instance_of?(NoisyBacktraceTweaker)
      end
      
      def test_backtrace_tweaker_should_be_noisy_with_backtrace
        options = OptionParser.parse(["--backtrace"], false, @err, @out)
        assert options.backtrace_tweaker.instance_of?(NoisyBacktraceTweaker)
      end
      
      def test_sweetener_should_be_required_with_sweet
        options = OptionParser.parse(["--sweet"], false, @err, @out)
      end
    end
  end
end

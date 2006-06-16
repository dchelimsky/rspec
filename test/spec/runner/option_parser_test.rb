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
        assert_match(/Usage: spec \[options\] \(FILE\|DIRECTORY\|GLOB\)\+/n, @out.read)
      end
      
      def test_verbose_should_be_false_by_default
        options = OptionParser.parse([], false, @err, @out)
        assert(!options.verbose)
      end

      def test_dry_run_should_be_settable
        options = OptionParser.parse(["--dry-run"], false, @err, @out)
        assert(options.dry_run)
      end

      def test_should_use_progress_bar_formatter_by_default
        options = OptionParser.parse([], false, @err, @out)
        assert_equal(Formatter::ProgressBarFormatter, options.formatter_type)
      end
      
      def test_should_use_specdoc_formatter_when_format_is_specdoc
        options = OptionParser.parse(["--format","specdoc"], false, @err, @out)
        assert_equal(Formatter::SpecdocFormatter, options.formatter_type)
      end

      def test_should_use_specdoc_formatter_when_format_is_s
        options = OptionParser.parse(["--format","s"], false, @err, @out)
        assert_equal(Formatter::SpecdocFormatter, options.formatter_type)
      end

      def test_should_use_rdoc_formatter_when_format_is_rdoc
        options = OptionParser.parse(["--format","rdoc"], false, @err, @out)
        assert_equal(Formatter::RdocFormatter, options.formatter_type)
      end
      
      def test_should_use_rdoc_formatter_when_format_is_r
        options = OptionParser.parse(["--format","r"], false, @err, @out)
        assert_equal(Formatter::RdocFormatter, options.formatter_type)
      end
      
      def test_should_use_html_formatter_when_format_is_html
        options = OptionParser.parse(["--format","html"], false, @err, @out)
        assert_equal(Formatter::HtmlFormatter, options.formatter_type)
      end
      
      def test_should_use_html_formatter_when_format_is_h
        options = OptionParser.parse(["--format","h"], false, @err, @out)
        assert_equal(Formatter::HtmlFormatter, options.formatter_type)
      end
      
      def test_should_select_dry_run_for_rdoc_formatter
        options = OptionParser.parse(["--format","rdoc"], false, @err, @out)
        assert(options.dry_run)
      end

      def test_should_eval_and_use_custom_formatter_when_none_of_the_builtins
        options = OptionParser.parse(["--format","Custom::Formatter"], false, @err, @out)
        assert_equal(Custom::Formatter, options.formatter_type)
      end

      def test_should_print_instructions_about_how_to_fix_bad_formatter
        options = OptionParser.parse(["--format","Custom::BadFormatter"], false, @err, @out)
        assert_match(/Couldn't find formatter class Custom::BadFormatter/n, @err.string)
      end
      
      def test_should_require_file_when_require_specified
        assert_raise(LoadError) do
          OptionParser.parse(["--require","whatever"], false, @err, @out)
        end
      end
      
      def test_should_print_usage_to_err_if_no_dir_specified
        options = OptionParser.parse([], false, @err, @out)
        assert_match(/Usage: spec/, @err.string)
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
      
      def test_should_support_single_spec_with_spec
        options = OptionParser.parse(["--spec","something or other"], false, @err, @out)
        assert_equal "something or other", options.spec_name
      end
      
      def test_should_support_single_spec_with_s
        options = OptionParser.parse(["-s","something or other"], false, @err, @out)
        assert_equal "something or other", options.spec_name
      end
    end
  end
end

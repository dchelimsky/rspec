require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
module Runner
context "OptionParser" do
    setup do
        @out = StringIO.new
        @err = StringIO.new
      
    end
    specify "should accept dry run option" do
      
        options=OptionParser.parse(["--dry-run"], false, @err, @out)
        options.dry_run.should_be(true)
      
    end
    specify "should eval and use custom formatter when none of the builtins" do
      
        options=OptionParser.parse(["--format", "Custom::Formatter"], false, @err, @out)
        options.formatter_type.should_eql(Custom::Formatter)
      
    end
    specify "should not be verbose by default" do
      
        options=OptionParser.parse([], false, @err, @out)
        (not options.verbose).should_be(true)
      
    end
    specify "should not use colour by default" do
      
        options=OptionParser.parse([], false, @err, @out)
        (not options.colour).should_be(true)
      
    end
    specify "should print help to stdout" do
      
        options=OptionParser.parse(["--help"], false, @err, @out)
        @out.rewind
        @out.read.should_match(/Usage: spec \[options\] \(FILE\|DIRECTORY\|GLOB\)\+/n)
      
    end
    specify "should print instructions about how to fix bad formatter" do
      
        options=OptionParser.parse(["--format", "Custom::BadFormatter"], false, @err, @out)
        @err.string.should_match(/Couldn't find formatter class Custom::BadFormatter/n)
      
    end
    specify "should print usage to err if no dir specified" do
      
        options=OptionParser.parse([], false, @err, @out)
        @err.string.should_match(/Usage: spec/)
      
    end
    specify "should print version to stdout" do
      
        options=OptionParser.parse(["--version"], false, @err, @out)
        @out.rewind
        @out.read.should_match(/RSpec-\d+\.\d+\.\d+ - BDD for Ruby\nhttp:\/\/rspec.rubyforge.org\/\n/n)
      
    end
    specify "should require file when require specified" do
        lambda do
          OptionParser.parse(["--require", "whatever"], false, @err, @out)
        end.should_raise(LoadError)
      
    end
    specify "should select dry run for rdoc formatter" do
      
        options=OptionParser.parse(["--format", "rdoc"], false, @err, @out)
        options.dry_run.should_be(true)
      
    end
    specify "should support c option" do
      
        options=OptionParser.parse(["-c"], false, @err, @out)
        options.colour.should_be(true)
      
    end
    specify "should support queens colour option" do
      
        options=OptionParser.parse(["--colour"], false, @err, @out)
        options.colour.should_be(true)
      
    end
    specify "should support single spec with s option" do
      
        options=OptionParser.parse(["-s", "something or other"], false, @err, @out)
        options.spec_name.should_eql("something or other")
      
    end
    specify "should support single spec with spec option" do
      
        options=OptionParser.parse(["--spec", "something or other"], false, @err, @out)
        options.spec_name.should_eql("something or other")
      
    end
    specify "should support us color option" do
      
        options=OptionParser.parse(["--color"], false, @err, @out)
        options.colour.should_be(true)
      
    end
    specify "should use html formatter when format is h" do
      
        options=OptionParser.parse(["--format", "h"], false, @err, @out)
        options.formatter_type.should_eql(Formatter::HtmlFormatter)
      
    end
    specify "should use html formatter when format is html" do
      
        options=OptionParser.parse(["--format", "html"], false, @err, @out)
        options.formatter_type.should_eql(Formatter::HtmlFormatter)
      
    end
    specify "should use noisy backtrace tweaker with b option" do
      
        options=OptionParser.parse(["-b"], false, @err, @out)
        options.backtrace_tweaker.instance_of?(NoisyBacktraceTweaker).should_be(true)
      
    end
    specify "should use noisy backtrace tweaker with backtrace option" do
      
        options=OptionParser.parse(["--backtrace"], false, @err, @out)
        options.backtrace_tweaker.instance_of?(NoisyBacktraceTweaker).should_be(true)
      
    end
    specify "should use progress bar formatter by default" do
      
        options=OptionParser.parse([], false, @err, @out)
        options.formatter_type.should_eql(Formatter::ProgressBarFormatter)
      
    end
    specify "should use quiet backtrace tweaker by default" do
      
        options=OptionParser.parse([], false, @err, @out)
        options.backtrace_tweaker.instance_of?(QuietBacktraceTweaker).should_be(true)
      
    end
    specify "should use rdoc formatter when format is r" do
      
        options=OptionParser.parse(["--format", "r"], false, @err, @out)
        options.formatter_type.should_eql(Formatter::RdocFormatter)
      
    end
    specify "should use rdoc formatter when format is rdoc" do
      
        options=OptionParser.parse(["--format", "rdoc"], false, @err, @out)
        options.formatter_type.should_eql(Formatter::RdocFormatter)
      
    end
    specify "should use specdoc formatter when format is s" do
      
        options=OptionParser.parse(["--format", "s"], false, @err, @out)
        options.formatter_type.should_eql(Formatter::SpecdocFormatter)
      
    end
    specify "should use specdoc formatter when format is specdoc" do
      
        options=OptionParser.parse(["--format", "specdoc"], false, @err, @out)
        options.formatter_type.should_eql(Formatter::SpecdocFormatter)
      
    end

    specify "should support diff option when format is not specified" do
      options = OptionParser.parse(["--diff"],false,@err,@out)
      options.diff_format.should_be :unified
    end

    specify "should use unified diff format option when format is unified" do
      options = OptionParser.parse(["--diff", "unified"],false,@err,@out)
      options.diff_format.should_be :unified
      options.differ_class.should_be Spec::Expectations::Differs::Default
    end

    specify "should use context diff format option when format is context" do
      options = OptionParser.parse(["--diff", "context"],false,@err,@out)
      options.diff_format.should_be :context
      options.differ_class.should_eql Spec::Expectations::Differs::Default
    end

    specify "should use custom diff format option when format is a custom format" do
      options = OptionParser.parse(["--diff", "Custom::Formatter"],false,@err,@out)
      options.diff_format.should_be :custom
      options.differ_class.should_eql Custom::Formatter
    end


    specify "should print instructions about how to fix bad differ" do
      options=OptionParser.parse(["--diff", "Custom::BadFormatter"], false, @err, @out)
      @err.string.should_match(/Couldn't find differ class Custom::BadFormatter/n)
    end
  
end
end
end

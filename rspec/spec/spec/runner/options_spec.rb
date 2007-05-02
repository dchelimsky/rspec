require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module Runner
    describe "Options" do
      before do
        @error_stream = StringIO.new('')
        @out_stream = StringIO.new('')
        @options = Options.new
      end

      it "instantiates empty arrays" do
        @options.examples.should == []
        @options.formatters.should == []
      end

      it "defaults to QuietBacktraceTweaker" do
        @options.backtrace_tweaker.class.should == QuietBacktraceTweaker
      end

      it "defaults to no dry_run" do
        @options.dry_run.should == false
      end

      it "parse_diff sets context_lines" do
        @options.parse_diff nil, @out_stream, @error_stream
        @options.context_lines.should == 3
      end

      it "defaults diff to unified" do
        @options.parse_diff nil, @out_stream, @error_stream
        @options.diff_format.should == :unified
      end

      it "should use unified diff format option when format is unified" do
        @options.parse_diff 'unified', @out_stream, @error_stream
        @options.diff_format.should == :unified
        @options.differ_class.should equal(Spec::Expectations::Differs::Default)
      end

      it "should use context diff format option when format is context" do
        @options.parse_diff 'context', @out_stream, @error_stream
        @options.diff_format.should == :context
        @options.differ_class.should == Spec::Expectations::Differs::Default
      end

      it "should use custom diff format option when format is a custom format" do
        @options.parse_diff "Custom::Formatter", @out_stream, @error_stream
        @options.diff_format.should == :custom
        @options.differ_class.should == Custom::Formatter
      end

      it "should print instructions about how to fix bad differ" do
        @options.parse_diff "Custom::BadFormatter", @out_stream, @error_stream
        @error_stream.string.should match(/Couldn't find differ class Custom::BadFormatter/n)
      end      

      it "parse_example sets single example when argument not a file" do
        example = "something or other"
        File.file?(example).should == false
        @options.parse_example example
        @options.examples.should eql(["something or other"])
      end

      it "parse_example sets examples to contents of file" do
        example = "#{File.dirname(__FILE__)}/examples.txt"
        File.should_receive(:file?).with(example).and_return(true)
        file = StringIO.new("Sir, if you were my husband, I would poison your drink.\nMadam, if you were my wife, I would drink it.")
        File.should_receive(:open).with(example).and_return(file)
        
        @options.parse_example example
        @options.examples.should eql([
          "Sir, if you were my husband, I would poison your drink.",
          "Madam, if you were my wife, I would drink it."
        ])
      end
    end    
  end
end

require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module Runner
    describe Options do
      before(:each) do
        @err = StringIO.new('')
        @out = StringIO.new('')
        @options = Options.new(@err, @out)
      end
      
      after(:each) do
        Spec::Expectations.differ = nil
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
        @options.parse_diff nil
        @options.context_lines.should == 3
      end

      it "defaults diff to unified" do
        @options.parse_diff nil
        @options.diff_format.should == :unified
      end

      it "should use unified diff format option when format is unified" do
        @options.parse_diff 'unified'
        @options.diff_format.should == :unified
        @options.differ_class.should equal(Spec::Expectations::Differs::Default)
      end

      it "should use context diff format option when format is context" do
        @options.parse_diff 'context'
        @options.diff_format.should == :context
        @options.differ_class.should == Spec::Expectations::Differs::Default
      end

      it "should use custom diff format option when format is a custom format" do
        Spec::Expectations.differ.should_not be_instance_of(Custom::Differ)
        
        @options.parse_diff "Custom::Differ"
        @options.diff_format.should == :custom
        @options.differ_class.should == Custom::Differ
        Spec::Expectations.differ.should be_instance_of(Custom::Differ)
      end

      it "should print instructions about how to fix missing differ" do
        lambda { @options.parse_diff "Custom::MissingDiffer" }.should raise_error(NameError)
        @err.string.should match(/Couldn't find differ class Custom::MissingDiffer/n)
      end      

      it "should print instructions about how to fix bad formatter" do
        lambda do
          @options.parse_format "Custom::BadFormatter"
        end.should raise_error(NameError, /undefined local variable or method `bad_method'/)
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

    describe Options, "#examples_run when there are behaviours" do
      before do
        @err = StringIO.new('')
        @out = StringIO.new('')
        @options = Options.new(@err, @out)
        @options.add_example_group Class.new(::Spec::DSL::ExampleGroup)
        @options.formatters << Formatter::BaseTextFormatter.new(@options, @out)
      end

      it "runs the Examples and outputs the result" do
        @options.run_examples
        @out.string.should include("0 examples, 0 failures")
      end
      
      it "sets #examples_run? to true" do
        @options.examples_run?.should be_false
        @options.run_examples
        @options.examples_run?.should be_true
      end
    end

    describe Options, "#examples_run when there are no behaviours" do
      before do
        @err = StringIO.new('')
        @out = StringIO.new('')
        @options = Options.new(@err, @out)
        @options.formatters << Formatter::BaseTextFormatter.new(@options, @out)
      end

      it "does not run Examples and does not output a result" do
        @options.run_examples
        @out.string.should_not include("examples")
        @out.string.should_not include("failures")
      end
      
      it "sets #examples_run? to false" do
        @options.examples_run?.should be_false
        @options.run_examples
        @options.examples_run?.should be_false
      end
    end

    describe Options, "#custom_runner?" do
      before do
        @err = StringIO.new('')
        @out = StringIO.new('')
        @options = Options.new(@err, @out)
      end
      
      it "returns true when there is a user_input_for_runner" do
        @options.user_input_for_runner = "Custom::BehaviourRunner"
        @options.custom_runner?.should be_true
      end

      it "returns false when there is no user_input_for_runner" do
        @options.user_input_for_runner = nil
        @options.custom_runner?.should be_false
      end
    end

    describe Options, "splitting class names and args" do
      before do
        @err = StringIO.new('')
        @out = StringIO.new('')
        @options = Options.new(@err, @out)
      end
      
      it "should split class names with args" do
        @options.split_at_colon('Foo').should == ['Foo', nil]
        @options.split_at_colon('Foo:arg').should == ['Foo', 'arg']
        @options.split_at_colon('Foo::Bar::Zap:arg').should == ['Foo::Bar::Zap', 'arg']
        @options.split_at_colon('Foo:arg1,arg2').should == ['Foo', 'arg1,arg2']
        @options.split_at_colon('Foo::Bar::Zap:arg1,arg2').should == ['Foo::Bar::Zap', 'arg1,arg2']
        @options.split_at_colon('Foo::Bar::Zap:drb://foo,drb://bar').should == ['Foo::Bar::Zap', 'drb://foo,drb://bar']
      end

      it "should raise error when splitting something starting with a number" do
        lambda { @options.split_at_colon('') }.should raise_error("Couldn't parse \"\"")
      end

      it "should raise error when not class name" do
        lambda do
          @options.load_class('foo', 'fruit', '--food')
        end.should raise_error('"foo" is not a valid class name')
      end
    end

    describe Options, "#differ_class and #differ_class=" do
      before do
        @err = StringIO.new
        @out = StringIO.new
        @options = Options.new(@err, @out)
      end

      it "does not set Expectations differ when differ_class is not set" do
        Spec::Expectations.should_not_receive(:differ=)
        @options.differ_class = nil
      end

      it "sets Expectations differ when differ_class is set" do
        Spec::Expectations.should_receive(:differ=).with(anything()).and_return do |arg|
          arg.class.should == Spec::Expectations::Differs::Default
        end
        @options.differ_class = Spec::Expectations::Differs::Default
      end
    end

    describe Options, "#reporter" do
      before do
        @err = StringIO.new
        @out = StringIO.new
        @options = Options.new(@err, @out)
      end

      it "returns a Reporter" do
        @options.reporter.should be_instance_of(Reporter)
        @options.reporter.options.should === @options
      end
    end

    describe Options, "#add_example_group affecting passed in behaviour" do
      before do
        @err = StringIO.new('')
        @out = StringIO.new('')
        @options = Options.new(@err, @out)
      end

      it "runs all examples when options.examples is nil" do
        example_1_has_run = false
        example_2_has_run = false
        @behaviour = Class.new(::Spec::DSL::ExampleGroup).describe("Some Examples") do
          it "runs 1" do
            example_1_has_run = true
          end
          it "runs 2" do
            example_2_has_run = true
          end
        end

        @options.examples = nil

        @options.add_example_group @behaviour
        @options.run_examples
        example_1_has_run.should be_true
        example_2_has_run.should be_true
      end

      it "keeps all example_definitions when options.examples is empty" do
        example_1_has_run = false
        example_2_has_run = false
        @behaviour = Class.new(::Spec::DSL::ExampleGroup).describe("Some Examples") do
          it "runs 1" do
            example_1_has_run = true
          end
          it "runs 2" do
            example_2_has_run = true
          end
        end

        @options.examples = []

        @options.add_example_group @behaviour
        @options.run_examples
        example_1_has_run.should be_true
        example_2_has_run.should be_true
      end
    end

    describe Options, "#add_example_group affecting behaviours" do
      before do
        @err = StringIO.new('')
        @out = StringIO.new('')
        @options = Options.new(@err,@out)
      end

      it "adds behaviour when behaviour has example_definitions and is not shared" do
        @behaviour = Class.new(::Spec::DSL::ExampleGroup).describe("Some Examples") do
          it "uses this behaviour" do
          end
        end

        @options.number_of_examples.should == 0
        @options.add_example_group @behaviour
        @options.number_of_examples.should == 1
        @options.example_groups.length.should == 1
      end
    end    
  end
end

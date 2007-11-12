require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module Runner
    options = describe Options, :shared => true do
      before(:each) do
        @err = StringIO.new('')
        @out = StringIO.new('')
        @options = Options.new(@err, @out)
      end
      
      after(:each) do
        Spec::Expectations.differ = nil
      end
    end

    describe Options, "#examples" do
      it_should_behave_like options

      it "defaults to empty array" do
        @options.examples.should == []
      end
    end

    describe Options, "#formatters" do
      it_should_behave_like options

      it "defaults to empty array" do
        @options.formatters.should == []
      end
    end

    describe Options, "#backtrace_tweaker" do
      it_should_behave_like options

      it "defaults to QuietBacktraceTweaker" do
        @options.backtrace_tweaker.class.should == QuietBacktraceTweaker
      end
    end


    describe Options, "#dry_run" do
      it_should_behave_like options

      it "defaults to false" do
        @options.dry_run.should == false
      end
    end

    describe Options, "#context_lines" do
      it_should_behave_like options

      it "defaults to 3" do
        @options.context_lines.should == 3
      end
    end

    describe Options, "#parse_diff" do
      it_should_behave_like options

      it "when receiving nil, makes diff_format unified" do
        @options.parse_diff nil
        @options.diff_format.should == :unified
      end

      it "when receiving 'unified', makes diff_format unified and uses default differ_class" do
        @options.parse_diff 'unified'
        @options.diff_format.should == :unified
        @options.differ_class.should equal(Spec::Expectations::Differs::Default)
      end

      it "when receiving 'context', makes diff_format context and uses default differ_class" do
        @options.parse_diff 'context'
        @options.diff_format.should == :context
        @options.differ_class.should == Spec::Expectations::Differs::Default
      end

      it "when receiving custom class name, uses custom differ_class" do
        Spec::Expectations.differ.should_not be_instance_of(Custom::Differ)
        
        @options.parse_diff "Custom::Differ"
        @options.diff_format.should == :custom
        @options.differ_class.should == Custom::Differ
        Spec::Expectations.differ.should be_instance_of(Custom::Differ)
      end

      it "when receiving missing class name, raises error" do
        lambda { @options.parse_diff "Custom::MissingDiffer" }.should raise_error(NameError)
        @err.string.should match(/Couldn't find differ class Custom::MissingDiffer/n)
      end
    end

    describe Options, "#parse_format" do
      it_should_behave_like options
      
      it "when receiving invalid class name, raises error" do
        lambda do
          @options.parse_format "Custom::BadFormatter"
        end.should raise_error(NameError, /undefined local variable or method `bad_method'/)
      end
    end      

    describe Options, "#parse_example" do
      it_should_behave_like options
      
      it "when receiving argument thats not a file path, sets argument as the example" do
        example = "something or other"
        File.file?(example).should == false
        @options.parse_example example
        @options.examples.should eql(["something or other"])
      end

      it "when receiving argument that is a file path, sets examples to contents of the file" do
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

    describe Options, "#run_examples", :shared => true do
      it "should use the standard runner by default" do
        runner = ::Spec::Runner::BehaviourRunner.new(@options)
        ::Spec::Runner::BehaviourRunner.should_receive(:new).
          with(@options).
          and_return(runner)
        @options.user_input_for_runner = nil
        
        @options.run_examples
      end

      it "should use a custom runner when given" do
        runner = Custom::BehaviourRunner.new(@options, nil)
        Custom::BehaviourRunner.should_receive(:new).
          with(@options, nil).
          and_return(runner)
        @options.user_input_for_runner = "Custom::BehaviourRunner"

        @options.run_examples
      end

      it "should use a custom runner with extra options" do
        runner = Custom::BehaviourRunner.new(@options, 'something')
        Custom::BehaviourRunner.should_receive(:new).
          with(@options, 'something').
          and_return(runner)
        @options.user_input_for_runner = "Custom::BehaviourRunner:something"

        @options.run_examples
      end
    end

    describe Options, "#run_examples when there are behaviours" do
      it_should_behave_like "Spec::Runner::Options#run_examples"
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

    describe Options, "#run_examples when there are no behaviours" do
      it_should_behave_like "Spec::Runner::Options#run_examples"
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
          @options.send(:load_class, 'foo', 'fruit', '--food')
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

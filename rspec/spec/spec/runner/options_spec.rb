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

    describe Options, "#parse_diff with nil" do
      it_should_behave_like options

      before do
        @options.parse_diff nil
      end

      it "should make diff_format unified" do
        @options.diff_format.should == :unified
      end

      it "should set Spec::Expectations.differ to be a default differ" do
        Spec::Expectations.differ.class.should ==
          ::Spec::Expectations::Differs::Default
      end
    end

    describe Options, "#parse_diff with 'unified'" do
      it_should_behave_like options

      before do
        @options.parse_diff 'unified'
      end

      it "should make diff_format unified and uses default differ_class" do
        @options.diff_format.should == :unified
        @options.differ_class.should equal(Spec::Expectations::Differs::Default)
      end

      it "should set Spec::Expectations.differ to be a default differ" do
        Spec::Expectations.differ.class.should ==
          ::Spec::Expectations::Differs::Default
      end
    end

    describe Options, "#parse_diff with 'context'" do
      it_should_behave_like options

      before do
        @options.parse_diff 'context'
      end

      it "should make diff_format context and uses default differ_class" do
        @options.diff_format.should == :context
        @options.differ_class.should == Spec::Expectations::Differs::Default
      end

      it "should set Spec::Expectations.differ to be a default differ" do
        Spec::Expectations.differ.class.should ==
          ::Spec::Expectations::Differs::Default
      end
    end

    describe Options, "#parse_diff with Custom::Differ" do
      it_should_behave_like options

      before do
        @options.parse_diff 'Custom::Differ'
      end
      
      it "should use custom differ_class" do
        @options.diff_format.should == :custom
        @options.differ_class.should == Custom::Differ
        Spec::Expectations.differ.should be_instance_of(Custom::Differ)
      end

      it "should set Spec::Expectations.differ to be a default differ" do
        Spec::Expectations.differ.class.should ==
          ::Custom::Differ
      end
    end

    describe Options, "#parse_diff with missing class name" do
      it_should_behave_like options

      it "should raise error" do
        lambda { @options.parse_diff "Custom::MissingDiffer" }.should raise_error(NameError)
        @err.string.should match(/Couldn't find differ class Custom::MissingDiffer/n)
      end
    end

    describe Options, "#parse_format" do
      it_should_behave_like options
      
      it "with invalid class name, raises error" do
        lambda do
          @options.parse_format "Custom::BadFormatter"
        end.should raise_error(NameError, /undefined local variable or method `bad_method'/)
      end
    end      

    describe Options, "#parse_example" do
      it_should_behave_like options
      
      it "with argument thats not a file path, sets argument as the example" do
        example = "something or other"
        File.file?(example).should == false
        @options.parse_example example
        @options.examples.should eql(["something or other"])
      end

      it "with argument that is a file path, sets examples to contents of the file" do
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

    describe Options, "#examples_should_not_be_run" do
      it_should_behave_like options

      it "should cause #run_examples to return true and do nothing" do
        @options.examples_should_not_be_run
        BehaviourRunner.should_not_receive(:new)
        
        @options.run_examples.should be_true
      end
    end

    describe Options, "#load_class" do
      it_should_behave_like options

      it "should raise error when not class name" do
        lambda do
          @options.send(:load_class, 'foo', 'fruit', '--food')
        end.should raise_error('"foo" is not a valid class name')
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

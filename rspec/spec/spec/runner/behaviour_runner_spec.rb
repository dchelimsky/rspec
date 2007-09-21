require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module Runner
    describe BehaviourRunner, "#add_behaviour affecting passed in behaviour" do
      before do
        @err = StringIO.new('')
        @out = StringIO.new('')
        @options = Options.new(@err,@out)
        @runner = BehaviourRunner.new(@options)
        class << @runner
          attr_reader :behaviours
        end
      end

      it "runs all examples when options.examples is nil" do
        example_1_has_run = false
        example_2_has_run = false
        @behaviour = Class.new(::Spec::DSL::Example).describe("A Behaviour") do
          it "runs 1" do
            example_1_has_run = true
          end
          it "runs 2" do
            example_2_has_run = true
          end
        end
        
        @options.examples = nil

        @runner.add_behaviour @behaviour
        @runner.run
        example_1_has_run.should be_true
        example_2_has_run.should be_true
      end

      it "keeps all example_definitions when options.examples is empty" do
        example_1_has_run = false
        example_2_has_run = false
        @behaviour = Class.new(::Spec::DSL::Example).describe("A Behaviour") do
          it "runs 1" do
            example_1_has_run = true
          end
          it "runs 2" do
            example_2_has_run = true
          end
        end
        
        @options.examples = []

        @runner.add_behaviour @behaviour
        @runner.run
        example_1_has_run.should be_true
        example_2_has_run.should be_true
      end
    end

    describe BehaviourRunner, "#add_behaviour affecting behaviours" do
      before do
        @err = StringIO.new('')
        @out = StringIO.new('')
        @options = Options.new(@err,@out)
        @runner = BehaviourRunner.new(@options)
        class << @runner
          attr_reader :behaviours
        end
      end

      it "adds behaviour when behaviour has example_definitions and is not shared" do
        @behaviour = Class.new(::Spec::DSL::Example).describe("A Behaviour") do
          it "uses this behaviour" do
          end
        end

        @behaviour.should_not be_shared
        @behaviour.number_of_examples.should be > 0
        @runner.add_behaviour @behaviour

        @runner.behaviours.length.should == 1
      end

      it "raises error when trying to add shared behaviour" do
        @behaviour = ::Spec::DSL::SharedBehaviour.new("A Example", :shared => true) do
          it "does not use this behaviour" do
          end
        end
        @behaviour.should be_shared
        proc do
          @runner.add_behaviour @behaviour
        end.should raise_error(
          ArgumentError,
          "Cannot add Shared Example to the BehaviourRunner"
        )

        @runner.behaviours.should be_empty
      end
    end

    describe BehaviourRunner, "#run" do
      before do
        @err = StringIO.new('')
        @out = StringIO.new('')
        @options = Options.new(@err,@out)
      end

      it "should dump even if Interrupt exception is occurred" do
        behaviour = Class.new(::Spec::DSL::Example).describe("behaviour") do
          it "no error" do
          end

          it "should interrupt" do
            raise Interrupt
          end
        end

        reporter = mock("reporter")
        reporter.should_receive(:start)
        reporter.should_receive(:add_behaviour)
        reporter.should_receive(:example_started).twice
        reporter.should_receive(:example_finished).twice
        reporter.should_receive(:rspec_verify)
        reporter.should_receive(:rspec_reset)
        reporter.should_receive(:end)
        reporter.should_receive(:dump)

        @options.reporter = reporter
        runner = Spec::Runner::BehaviourRunner.new(@options)
        runner.add_behaviour(behaviour)
        runner.run
      end

      it "should heckle when options have heckle_runner" do
        behaviour = mock("behaviour", :null_object => true)
        behaviour.should_receive(:number_of_examples).and_return(1)
        behaviour.should_receive(:run).and_return(0)
        behaviour.should_receive(:shared?).and_return(false)

        reporter = mock("reporter")
        reporter.should_receive(:start).with(1)
        reporter.should_receive(:end)
        reporter.should_receive(:dump).and_return(0)

        heckle_runner = mock("heckle_runner")
        heckle_runner.should_receive(:heckle_with)

        @options.reporter = reporter
        @options.heckle_runner = heckle_runner

        runner = Spec::Runner::BehaviourRunner.new(@options)
        runner.add_behaviour(behaviour)
        runner.run
      end

      it "should run examples backwards if options.reverse is true" do
        @options.reverse = true

        reporter = mock("reporter")
        reporter.should_receive(:start).with(3)
        reporter.should_receive(:end)
        reporter.should_receive(:dump).and_return(0)
        @options.reporter = reporter

        runner = Spec::Runner::BehaviourRunner.new(@options)
        b1 = Class.new(Spec::DSL::Example)
        b1.should_receive(:number_of_examples).and_return(1)
        b1.should_receive(:shared?).and_return(false)
        b1.should_receive(:set_sequence_numbers).with(12, true).and_return(18)

        b2 = Class.new(Spec::DSL::Example)
        b2.should_receive(:number_of_examples).and_return(2)
        b2.should_receive(:shared?).and_return(false)
        b2.should_receive(:set_sequence_numbers).with(0, true).and_return(12)

        b2_suite = b2.suite
        b2.should_receive(:suite).and_return(b2_suite)
        b1_suite = b1.suite
        b1.should_receive(:suite).and_return(b1_suite)

        b2_suite.should_receive(:run).ordered
        b1_suite.should_receive(:run).ordered

        runner.add_behaviour(b1)
        runner.add_behaviour(b2)

        runner.run
      end

      it "should pass its Description to the reporter" do
        behaviour = Class.new(::Spec::DSL::Example).describe("behaviour") do
          it "should" do
          end
        end

        reporter = mock("reporter", :null_object => true)
        reporter.should_receive(:add_behaviour).with(an_instance_of(Spec::DSL::BehaviourDescription))

        @options.reporter = reporter
        runner = Spec::Runner::BehaviourRunner.new(@options)
        runner.add_behaviour(behaviour)
        runner.run
      end

      it "runs only selected Examples when options.examples is set" do
        @options.examples << "behaviour should"
        should_has_run = false
        should_not_has_run = false
        behaviour = Class.new(::Spec::DSL::Example).describe("behaviour") do
          it "should" do
            should_has_run = true
          end
          it "should not" do
            should_not_has_run = true
          end
        end

        reporter = mock("reporter", :null_object => true)
        reporter.should_receive(:add_behaviour).with(an_instance_of(Spec::DSL::BehaviourDescription))
        @options.reporter = reporter

        runner = Spec::Runner::BehaviourRunner.new(@options)
        runner.add_behaviour behaviour
        runner.run

        should_has_run.should be_true
        should_not_has_run.should be_false
      end
    end
  end
end
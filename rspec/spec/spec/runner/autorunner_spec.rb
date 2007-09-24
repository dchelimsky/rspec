require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Test
  module Unit
    describe AutoRunner, ".new" do
      before :all do
        @original_rspec_options = $rspec_options
      end

      before :each do
        @options = ::Spec::Runner::Options.new(StringIO.new, StringIO.new)
        $rspec_options = @options
      end

      after :each do
        $rspec_options = @original_rspec_options
      end

      it "returns an instance of AutoRunner when not using a custom runner" do
        runner = AutoRunner.new(true)
        runner.should be_instance_of(AutoRunner)
      end

      it "returns an instance of a custom runner when one is specified" do
        @options.runner_arg = "Custom::BehaviourRunner"
        runner = AutoRunner.new(true)
        runner.should be_instance_of(::Custom::BehaviourRunner)
      end
    end

    describe AutoRunner, "#process_args" do
      it "should always return true" do
        runner = AutoRunner.new(true)
        runner.process_args(['-b']).should be_true
      end
    end
  end
end
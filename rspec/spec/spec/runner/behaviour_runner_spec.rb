require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module Runner
    describe BehaviourRunner, "#options" do
      it "returns an Options object" do
        behaviour_runner.options.should be_instance_of(Options)
      end
    end
  end
end
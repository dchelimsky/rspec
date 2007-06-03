require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module Rails
    module DSL
      describe ModelBehaviour do
        it "should tell you its behaviour_type is :model" do
          behaviour = ModelBehaviour.new("") {}
          behaviour.behaviour_type.should == :model
        end
      end
    end
  end
end

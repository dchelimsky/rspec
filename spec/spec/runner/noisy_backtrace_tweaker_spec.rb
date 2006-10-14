require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
module Runner
context "NoisyBacktraceTweaker" do
    setup do
        @error = RuntimeError.new
        @tweaker = NoisyBacktraceTweaker.new
      
    end
    specify "should leave anything in lib spec dir" do
        ["expectations", "mocks", "runner", "stubs"].each do |child|
            @error.set_backtrace(["/lib/spec/#{child}/anything.rb"])
            @tweaker.tweak_backtrace(@error, "spec name")
            @error.backtrace.should_not_be_empty
          
        end
      
    end
    specify "should leave anything in spec dir" do
        @error.set_backtrace(["/lib/spec/expectations/anything.rb"])
        @tweaker.tweak_backtrace(@error, "spec name")
        @error.backtrace.should_not_be_empty
      
    end
    specify "should leave bin spec" do
        @error.set_backtrace(["bin/spec:"])
        @tweaker.tweak_backtrace(@error, "spec name")
        @error.backtrace.should_not_be_empty
      
    end
    specify "should not barf on nil backtrace" do
        lambda do
          @tweaker.tweak_backtrace(@error, "spec name")
        end.should_not_raise
      
    end
    specify "should replace   instance exec with spec name" do
        @error.set_backtrace(["./examples/airport_spec.rb:28:in `__instance_exec_1014688_1661744'"])
        @tweaker.tweak_backtrace(@error, "spec name")
        @error.backtrace[0].should_equal("./examples/airport_spec.rb:28:in `spec name'")
      
    end
  
end
end
end
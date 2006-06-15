module Spec

  class InstanceNegator < ShouldBase
  
    def initialize(target)
      @target = target
    end
    
    def of(expected_class)
      fail_with_message(default_message("should not be an instance of", expected_class)) if @target.instance_of? expected_class
    end
    
  end

end
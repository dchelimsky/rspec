module Spec

  class InstanceHelper < ShouldBase
  
    def initialize(target)
      @target = target
    end
    
    def of(expected_class)
      fail_with_message(default_message("should be an instance of", expected_class)) unless @target.instance_of? expected_class
    end
    
  end

end
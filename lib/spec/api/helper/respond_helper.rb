module Spec

  class RespondHelper < ShouldBase
  
    def initialize(target)
      @target = target
    end
    
    def to(expected)
      fail_with_message(default_message("should respond to", expected)) unless @target.respond_to? expected
    end
    
  end

end
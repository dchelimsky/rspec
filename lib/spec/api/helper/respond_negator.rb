module Spec

  class RespondNegator < ShouldBase
  
    def initialize(target)
      @target = target
    end
    
    def to(expected)
      fail_with_message(default_message("should not respond to", expected)) if @target.respond_to? expected
    end
    
  end

end
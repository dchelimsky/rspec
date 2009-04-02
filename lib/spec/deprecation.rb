module Spec
  class << self
    def deprecate(method, alternate_method=nil)
       message = <<-NOTICE

DEPRECATION WARNING: you are using deprecated behaviour that will
be removed from a future version of RSpec.

#{method} is deprecated.
NOTICE
      if alternate_method
        message << <<-ADDITIONAL
Please use #{alternate_method} instead.
ADDITIONAL
      end
      
      message << <<-MORE

#{caller(0)[2]}
MORE
      warn(message)
    end
    
    def warn(message)
      Kernel.warn(message)
    end
  end
end


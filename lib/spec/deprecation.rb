module Spec
  class << self
    def deprecate(method, alternate_method=nil)
       message = <<-NOTICE

*****************************************************************
DEPRECATION WARNING: you are using deprecated behaviour that will
be removed from a future version of RSpec.

#{caller(0)[2]}

* #{method} is deprecated.
NOTICE
      if alternate_method
        message << <<-ADDITIONAL
* please use #{alternate_method} instead.
ADDITIONAL
      end
      
      message << "*****************************************************************"
      warn(message)
    end
    
    def warn(message)
      Kernel.warn(message)
    end
  end
end


module Spec
  module Stubs
    class StubMethod
      module InstanceMethods
        def initialize(target, method_name, &block)
          @target = target
          @method_name = method_name
        end

        def and_return(value=nil, &block)
          if block
            method_instance = block
          else
            method_instance = proc {value}
          end
          @target.send(:__define_proxy_method!, @method_name, method_instance)
          self
        end
      end
      include InstanceMethods
    end
  end
end

module Spec
  module Stubs
    class Stub
      module InstanceMethods
        attr_writer :space
        
        def initialize(target, name="")
          @target = target
          @name = name
        end

        def method(method_name, &block)
          if block
            @space.create_method(@target, method_name).with(&block)
          else
            @space.create_method(@target, method_name)
          end
        end

        def __target
          @target
        end

        def __name
          @name
        end
      end
      include InstanceMethods
    end
  end
end

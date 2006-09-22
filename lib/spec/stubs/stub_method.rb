module Spec
  module Stubs
    class StubMethod
      module InstanceMethods
        attr_writer :space
        attr_reader :old_method, :stub_set

        def initialize(target, method_name, &block)
          @target = target
          @method_name = method_name
          @stub_set = false
        end

        def call(*args)
          @method_instance.call(*args)
        end

        def with(value=nil, &block)
          raise "Stub has already been set" if @stub_set
          @stub_set = true
          if block
            @method_instance = block
          else
            @method_instance = proc {value}
          end
          if(@target.respond_to?(@method_name))
            @old_method = @target.method(@method_name)
          end
          @space.registry[@target, @method_name] = self
          space = @space
          @target.instance_eval {@__stub_space = space}
          stub_method_source = "def #{@method_name}(*args, &block)\n"
          stub_method_source << "@__stub_space.registry.invoke(self, :#{@method_name}, args, &block)\n"
          stub_method_source << "end"
          target_class.class_eval stub_method_source, __FILE__, __LINE__-3
          self
        end

        def reset!
          return unless @stub_set
          method_name, old_method = @method_name, @old_method

          if old_method
            target_class.class_eval do
              define_method method_name, &old_method
            end
          else
            target_class.class_eval do
              remove_method method_name
            end
          end
        end

        private
        def target_class
          (class << @target; self; end)
        end
      end
      include InstanceMethods
    end
  end
end

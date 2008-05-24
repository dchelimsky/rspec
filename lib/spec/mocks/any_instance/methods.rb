module Spec
  module Mocks
    module AnyInstance
      module Methods
        # See the documentation under Spec::Mocks::AnyInstance
        def any_instance
          yield __any_instance_proxy__ if block_given?
          __any_instance_proxy__
        end

        def __rspec_clear_instances__
          __any_instance_proxy__.reset
        end

        private
        def __any_instance_proxy__
          @__any_instance_proxy__ ||= AnyInstanceProxy.new(self)
        end
      end
    end
  end
end

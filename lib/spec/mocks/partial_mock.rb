module Spec
  module Mocks
    module PartialMock
      def should_receive(method_name)
        __insert_partial_mock_method(method_name)
        return __partial_mock.should_receive(method_name)
      end

      def should_not_receive(method_name)
        __insert_partial_mock_method(method_name)
        return __partial_mock.should_not_receive(method_name)
      end

      protected
      def __insert_partial_mock_method(method_name)
        __define_proxy_method!(
          method_name, 
          lambda do |*args|
            __partial_mock.__send__(method_name, *args)
          end
        )
      end

      def __partial_mock
        unless @__partial_mock
          @__partial_mock = ::Spec::Mocks::Mock.new(self.class.to_s)
          __on_reset_proxied_methods do
            begin
              @__partial_mock.__verify
            ensure
              @__partial_mock.__clear_expectations
            end
          end
        end
        @__partial_mock
      end
    end
  end
end
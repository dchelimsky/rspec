module Spec
  module Mocks
    module AnyInstance
      class AnyInstanceProxy

        def initialize(target)
          @target = target
          @stubbed_methods = []
        end

        def stub!(message)
          stubber = MethodStubber.new @target, message
          stubber.add_stub
          register_stub stubber
          stubber
        end

        def reset
          @stubbed_methods.each { |object| object.reset! }
        end

        private

        def register_stub(stubber)
          $rspec_mocks.add stubber
          @stubbed_methods << stubber
        end
      end
    end
  end
end

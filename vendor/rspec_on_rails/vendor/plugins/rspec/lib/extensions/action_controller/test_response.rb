module ActionController
  class TestResponse
    module InstanceMethodsForRSpec
      def should_be_success
        raise Spec::Expectations::ExpectationNotMetError.new("expected response to be success but was not") unless success?
      end
      
      def success?
        return true if @isolate_from_views
        super
      end
      
      def should_be_redirect
        raise Spec::Expectations::ExpectationNotMetError.new("expected response to be redirect but was not") unless redirect?
      end
      
      def redirect?
        return true if @performed_redirect_for_rspec
        super
      end
      
      def should_have_rjs element, *args
        __response_body.should_have_rjs element, *args
      end

      def should_not_have_rjs element, *args
        __response_body.should_not_have_rjs element, *args
      end

      def should_have_tag tag, *opts
        __response_body.should_have_tag tag, *opts
      end

      def should_not_have_tag tag, *opts
        __response_body.should_not_have_tag tag, *opts
      end
      
      def isolate_from_views!
        @isolate_from_views = true
      end

      private
      def __response_body
        Spec::Rails::ResponseBody.new(self.body)
      end
    end
    include InstanceMethodsForRSpec
  end
end
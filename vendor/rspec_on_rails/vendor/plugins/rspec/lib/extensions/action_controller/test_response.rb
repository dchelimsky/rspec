module ActionController
  class TestResponse
    
    module InstanceMethodsForRSpec
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
      
      private
      def __response_body
        Spec::Rails::ResponseBody.new(self.body)
      end
    end
    
    include InstanceMethodsForRSpec

  end
end
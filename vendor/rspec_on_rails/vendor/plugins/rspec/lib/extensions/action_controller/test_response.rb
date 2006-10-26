module ActionController
  class TestResponse
    module InstanceMethodsForRspec
      def should_be_success
        #TODO - need to figure out what to do w/ this
        return true if @isolate_from_views
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
    include InstanceMethodsForRspec
  end
end
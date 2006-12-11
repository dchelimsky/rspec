module ActionController
  class TestResponse
    
    module InstanceMethodsForRSpec
      def should_have_rjs(element, *args, &block)
        __response_body.should_have_rjs element, *args
      end

      def should_not_have_rjs(element, *args)
        __response_body.should_not_have_rjs element, *args
      end

      def should_have_tag(tag, *opts)
        __response_body.should_have_tag tag, *opts
      end

      def should_not_have_tag(tag, *opts)
        __response_body.should_not_have_tag tag, *opts
      end
      
      def should_have(*args, &block)
        __assert_select_wrapper.should_have(*args, &block)
      end
      
      def should_have_feed(type, version=nil, &block)
        __assert_select_wrapper.should_have_feed(type, version, &block)
      end
      
      def should_have_encoded(element=nil, &block)
        __assert_select_wrapper.should_have_encoded(element, &block)
      end
      
      def should_have_email(&block)
        __assert_select_wrapper.should_have_email(&block)
      end
      
      def should_redirect_to(url)
        unless redirect?
          message = %Q{expected redirect to #{url} but there was no redirect}
          raise Spec::Expectations::ExpectationNotMetError.new(message)
        end
        redirect_url.should == url
      end
      
      private
      def __response_body
        Spec::Rails::ResponseBody.new(self.body)
      end
      
      def __assert_select_wrapper
        @__assert_select_wrapper ||= Spec::Rails::AssertSelectWrapper.new(self)
      end
    end
    
    include InstanceMethodsForRSpec

  end
end
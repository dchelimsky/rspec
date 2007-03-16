module ActionController #:nodoc:
  class TestResponse #:nodoc:
    
    module InstanceMethodsForRSpec #:nodoc:
      # Deprecated - gone for 9.0
      # Use should be_success #see Spec::Rails::Expectations::Matchers
      def should_be_success
        unless success?
          message = %Q{response code should be success (200) but }
          if redirect?
            message += %Q{was redirect (#{response_code}) to }
            # Rails 1.1.6 & 1.2.0 RC 1
            message += headers['location'] if headers['location']
            # Rails 1.2.0
            message += headers['Location'] if headers['Location']
          else
            message += "was (#{response_code})"
          end
          Spec::Expectations.fail_with(message)
        end
      end
      
      # Deprecated - gone for 9.0
      # Use should be_rjs #see Spec::Rails::Expectations::Matchers
      def should_have_rjs(element, *args, &block)
        __response_body.should_have_rjs element, *args
      end

      # Deprecated - gone for 9.0
      # Use should_not be_rjs #see Spec::Rails::Expectations::Matchers
      def should_not_have_rjs(element, *args)
        __response_body.should_not_have_rjs element, *args
      end

      # Deprecated - gone for 9.0
      # Use should have_tag #see Spec::Rails::Expectations::Matchers
      def should_have_tag(tag, *opts)
        __response_body.should_have_tag tag, *opts
      end

      # Deprecated - gone for 9.0
      # Use should_not have_tag #see Spec::Rails::Expectations::Matchers
      def should_not_have_tag(tag, *opts)
        __response_body.should_not_have_tag tag, *opts
      end
            
      # Deprecated - gone for 9.0
      # Use should redirect_to #see Spec::Rails::Expectations::Matchers
      def should_redirect_to(url)
        unless redirect?
          Spec::Expectations.fail_with(%Q{expected redirect to #{to_url(url)} but there was no redirect})
        end
        Spec::Expectations.fail_with(%Q{expected redirect to #{to_url(url)} but was redirected to #{redirect_url} instead}) unless  redirect_url == to_url(url)
      end
      
      def to_url(opts)
        case opts
          when %r{^\w+://.*}
            return opts
          else
            return 'http://test.host' + (opts.split('')[0] == '/' ? '' : '/') + opts
        end
      end
      
      attr_writer :controller_path

    private

      attr_reader :controller_path
      
      def __response_body
        Spec::Rails::Expectations::ResponseBody.new(self.body)
      end
    end
    
    include InstanceMethodsForRSpec

  end
end
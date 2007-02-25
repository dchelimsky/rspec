require 'action_controller/url_rewriter'

module Spec
  module Rails
    module Expectations
      module Matchers
      
        class RedirectTo  #:nodoc:
      
          def initialize(request, expected)
            @expected = expected
            @request = request
          end

          def matches?(response)
            @redirected = response.redirect?
            @actual = response.redirect_url
            return @actual == expected_url if @redirected
            return false
          end
        
          def expected_url
            case @expected
              when Hash
                return ActionController::UrlRewriter.new(@request, {}).rewrite(@expected)
              when :back
                return @request.env['HTTP_REFERER']
              when %r{^\w+://.*}
                return @expected
              else
                return 'http://test.host' + (@expected.split('')[0] == '/' ? '' : '/') + @expected
            end
          end
        
          def failure_message
            if @redirected
              return %Q{expected redirect to #{@expected.inspect}, got redirect to #{@actual.inspect}}
            else
              return %Q{expected redirect to #{@expected.inspect}, got no redirect}
            end
          end
          
          def description
            "redirect to #{@actual.inspect}"
          end
        end

        # :call-seq:
        #   response.should redirect_to(url)
        #   response.should redirect_to(:action => action_name)
        #   response.should redirect_to(:controller => controller_name, :action => action_name)
        #   response.should_not redirect_to(url)
        #   response.should_not redirect_to(:action => action_name)
        #   response.should_not redirect_to(:controller => controller_name, :action => action_name)
        #
        # Passes if the response is a redirect to the url, action or controller/action.
        # Useful in controller specs (integration or isolation mode).
        #
        # == Examples
        #
        #   response.should redirect_to("path/to/action")
        #   response.should redirect_to("http://test.host/path/to/action")
        #   response.should redirect_to(:action => 'list')
        def redirect_to(opts)
          RedirectTo.new(request, opts)
        end
      end

    end
  end
end
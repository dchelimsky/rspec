require 'action_controller/url_rewriter'

module Spec
  module Rails
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
      end

    end
  end
end

require 'action_controller/url_rewriter'

module Spec
  module Rails
    module Matchers
      class RedirectTo  #:nodoc:
        def initialize(controller, expected)
          @expected = expected
          @controller = controller
        end

        def matches?(response)
          @redirected = response.redirect?
          @actual = response.redirect_url
          return @actual == expected_url if @redirected
          return false
        end
        
        def expected_url
          if Hash === @expected
            opts = @expected.clone
            unless opts.has_key?(:controller)
              opts = {:controller => (@controller.class.name.underscore[0..-12])}.merge(opts)
            end
            return generic_url_rewriter.rewrite(opts)
          elsif (@expected == :back)
            return @controller.request.env['HTTP_REFERER']
          elsif (@expected =~ /^http/)
            return @expected
          elsif (@expected =~ /^\//)
            return "http://test.host#{@expected}"
          else
            return "http://test.host/#{@expected}"
          end
        end
        
        def failure_message
          if @redirected
            return %Q{expected redirect to #{@expected.inspect}, got redirect to #{@actual.inspect}}
          else
            return %Q{expected redirect to #{@expected.inspect}, got no redirect}
          end
        end
        
        def negative_failure_message
          "blah"
        end

        # Get a temporarly URL writer object
        def generic_url_rewriter
          cgi = MockCGI.new('REQUEST_METHOD' => "GET",
                            'QUERY_STRING'   => "",
                            "REQUEST_URI"    => "/",
                            "HTTP_HOST"      => "test.host",
                            "SERVER_PORT"    => "80",
                            "HTTPS"          => "off")                          
                            # "SERVER_PORT"    => https? ? "443" : "80",
                            # "HTTPS"          => https? ? "on" : "off")                          
          ActionController::UrlRewriter.new(ActionController::CgiRequest.new(cgi), {})
        end

        class MockCGI < CGI #:nodoc:
          attr_accessor :stdinput, :stdoutput, :env_table

          def initialize(env, input=nil)
            self.env_table = env
            self.stdinput = StringIO.new(input || "")
            self.stdoutput = StringIO.new
            super()
          end
        end
      end
    end
  end
end

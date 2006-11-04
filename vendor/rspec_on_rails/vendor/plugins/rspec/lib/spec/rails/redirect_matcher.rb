module Spec
  module Rails
    class RedirectMatcher
      
      def set_expected(opts)
        @expected_opts = opts
        @should_redirect_mock = Spec::Mocks::Mock.new("should redirect")
        @should_redirect_mock.should_receive(
          :redirect_to,
          :expected_from => caller(0)[2],
          :message => "controller expected call to redirect_to #{opts.inspect} but it was never received"
        ).with(opts)
      end
      
      def match(request, opts)
        @should_redirect_mock.__reset_mock unless @should_redirect_mock.nil?
        case @expected_opts
          when Hash
            expected_url = ActionController::UrlRewriter.new(request, {}).rewrite(@expected_opts)
            unless expected_url == opts
              raise_should_redirect_error(@expected_opts, opts)
            end
          when :back
            unless request.env['HTTP_REFERER'] == opts
              raise_should_redirect_error(@expected_opts, opts)
            end
          when %r{^\w+://.*}
            unless @expected_opts == opts
              raise_should_redirect_error(@expected_opts, opts)
            end
          else
            expected_url = 'http://test.host' + (@expected_opts.split('')[0] == '/' ? '' : '/') + @expected_opts
            unless expected_url == opts
              raise_should_redirect_error(@expected_opts, opts)
            end
        end
      end
      
      def interested_in?(opts)
        opts.is_a?(String) && %r{^\w+://.*} =~ opts        
      end
      
      def raise_should_redirect_error expected, actual
        message = "expected redirect to #{expected.inspect}"
        message << " but redirected to #{actual.inspect} instead"
        raise Spec::Expectations::ExpectationNotMetError.new(message)
      end
    end
  end
end

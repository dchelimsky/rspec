module Spec
  module Rails
    class RedirectMatcher

      def interested_in?(opts)
        opts.is_a?(String) && %r{^\w+://.*} =~ opts        
      end
      
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
        return if @expected_opts.nil?
        expected_url = to_url(request, @expected_opts)
        actual_url = to_url(request, opts)
        raise_should_redirect_error(@expected_opts, opts) unless expected_url == actual_url
      end
      
      private
      def to_url(request, opts)
        case opts
          when Hash
            return ActionController::UrlRewriter.new(request, {}).rewrite(opts)
          when :back
            return request.env['HTTP_REFERER']
          when %r{^\w+://.*}
            return opts
          else
            return 'http://test.host' + (opts.split('')[0] == '/' ? '' : '/') + opts
        end
      end
      
      def raise_should_redirect_error(expected, actual)
        message = "expected redirect to #{expected.inspect}"
        message << " but redirected to #{actual.inspect} instead"
        raise Spec::Expectations::ExpectationNotMetError.new(message)
      end
    end
  end
end

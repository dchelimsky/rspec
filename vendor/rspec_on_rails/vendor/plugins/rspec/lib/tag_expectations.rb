module Spec
  module Expectations
    module TagExpectations
      def should_have_tag(*opts)
        raise_rspec_error(" should include ", opts) if find_tag(*opts).nil?
      end

      def should_not_have_tag(*opts)
        raise_rspec_error(" should not include ", opts) unless find_tag(*opts).nil?
      end

      private 

      def raise_rspec_error(message, *opts)
        Kernel::raise(Spec::Expectations::ExpectationNotMetError.new(self + message + opts.inspect))
      end

      def find_tag(*opts)
        opts = opts.size > 1 ? opts.last.merge({ :tag => opts.first.to_s }) : opts.first
        HTML::Document.new(self).find(opts)
      end
    end
  end
end

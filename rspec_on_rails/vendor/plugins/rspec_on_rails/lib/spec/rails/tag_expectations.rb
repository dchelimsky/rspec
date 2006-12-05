module Spec
  module Rails
    module TagExpectations
      def should_have_tag(*opts)
        raise_rspec_error(" should include ", opts.inspect) if find_tag(*opts).nil?
      end

      def should_not_have_tag(*opts)
        raise_rspec_error(" should not include ", opts.inspect) unless find_tag(*opts).nil?
      end

      private 

      def raise_rspec_error(message, *opts)
        Kernel::raise(Spec::Expectations::ExpectationNotMetError.new(@response_body + message + opts.inspect))
      end

      def find_tag(*opts)
        opts = OptsMerger.new(opts).merge(:tag)
        unless opts[:tag].to_s =~ /^\w+$/
          message = %-

SyntaxError in should_have_tag(tag, *opts)
* tag should be the name of the tag (like 'div', or 'select' without '<' or '>')
* opts should be a Hash of key value pairs

-
          raise Spec::Expectations::ExpectationNotMetError.new(message)
        end
          
        HTML::Document.new(@response_body).find(opts)
      end
    end
  end
end
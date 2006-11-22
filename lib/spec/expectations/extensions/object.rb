module Spec
  module Expectations
    module ObjectExpectations
      def should
        Should::Should.new self
      end

      def should_not
        should.not
      end

      def should_equal(arg)
        should.equal(arg)
      end

      def should_not_equal(arg)
        should.not.equal(arg)
      end

      def should_eql(arg)
        should.eql(arg)
      end

      def should_not_eql(arg)
        should.not.eql(arg)
      end

      def should_have(arg)
        should.have(arg)
      end
      alias_method :should_have_exactly, :should_have

      def should_have_at_least(arg)
        should.have.at_least(arg)
      end

      def should_have_at_most(arg)
        should.have.at_most(arg)
      end

      def should_include(arg)
        should.include(arg)
      end

      def should_not_include(arg)
        should.not.include(arg)
      end
      
      def should_change(receiver, message)
        should.change(receiver, message)
      end
      
      def should_not_change(receiver, message)
        should.not.change(receiver, message)
      end
      
      def should_be(expected = :___no_arg)
        should.be(expected)
      end
      
      def should_not_be(expected = :___no_arg)
        should.not.be(expected)
      end
      
      def should_satisfy &block
        should.satisfy &block
      end
      
      def should_not_satisfy &block
        should.not.satisfy &block
      end
      
      def should_be_an_instance_of(expected_class)
        should.be.an_instance_of(expected_class)
      end
      alias_method :should_be_instance_of, :should_be_an_instance_of
      
      def should_not_be_an_instance_of(expected_class)
        should.not.be.an_instance_of(expected_class)
      end
      
      def should_be_a_kind_of(expected_class)
        should.be.a_kind_of(expected_class)
      end
      alias_method :should_be_kind_of, :should_be_a_kind_of
      
      def should_not_be_a_kind_of(expected_class)
        should.not.be.a_kind_of(expected_class)
      end
      
      def should_respond_to(message)
        should.respond_to(message)
      end
      
      def should_not_respond_to(message)
        should.not.respond_to(message)
      end
      
      def should_match(expression)
        should.match(expression)
      end
      
      def should_not_match(expression)
        should.not.match(expression)
      end
      
      def should_raise(exception=Exception, message=nil)
        should.raise(exception, message)
      end
      
      def should_not_raise(exception=Exception, message=nil)
        should.not.raise(exception, message)
      end
      
      def should_throw(symbol)
        should.throw(symbol)
      end
      
      def should_not_throw(symbol=:___this_is_a_symbol_that_will_likely_never_occur___)
        should.not.throw(symbol)
      end
    end
  end
end

class Object
  include Spec::Expectations::ObjectExpectations
  include Spec::Expectations::UnderscoreSugar
end

Object.handle_underscores_for_rspec!

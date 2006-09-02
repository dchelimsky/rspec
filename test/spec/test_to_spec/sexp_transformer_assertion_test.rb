require File.dirname(__FILE__) + '/../../test_helper'
require 'test/unit'
require 'rubygems'
require 'parse_tree'
require 'spec/test_to_spec/sexp_transformer'

module Spec
  module TestToSpec
    # This Test::Unit class verifies that the core Test::Unit assertions
    # can be translated to RSpec.
    # The various test_assert_* methods must follow a rigorous form - 
    #
    # The first statement must be a Test::Unit assertion, and the second
    # statement its expected RSpec translation.
    #
    # For each of the test_assert_* method, a test_assert_*_translation
    # method is dynamically added, which will test that the translation
    # of the 1st statement is effectively equal to the second one.
    class SexpTransformerAssertionTest < Test::Unit::TestCase
      def setup
        @t = SexpTransformer.new
      end
      
      def test_assert
        assert(:foo == :foo)
        (:foo == :foo).should_be true
      end

      def test_assert_with_message
        assert(:foo == :foo, "msg")
        (:foo == :foo).should_be true
      end

      def test_assert_nil
        assert_nil([].index(5))
        ([].index(5)).should_be nil
      end

      def test_assert_nil_with_message
        assert_nil([].index(5), "msg")
        ([].index(5)).should_be nil
      end

      def test_assert_not_nil
        assert_not_nil([5].index(5))
        ([5].index(5)).should_not_be nil
      end

      def test_assert_not_nil_with_message
        assert_not_nil(3, "msg")
        3.should_not_be nil
      end

      def test_assert_equal
        assert_equal(2, 1+1)
        (1+1).should_equal 2
      end

      def test_assert_equal_with_message
        assert_equal(2, 1+1, "1+1 should equal 2")
        (1+1).should_equal 2
      end

      def test_assert_equal_with_each
        [0,1,2].each_with_index do |b, c|
          assert_equal c, b
        end
        [0,1,2].each_with_index do |b, c|
          b.should_equal c
        end
      end

      def test_assert_not_equal
        assert_not_equal(2+3, 1)
        1.should_not_equal 2+3
      end

      def test_assert_not_equal_with_message
        assert_not_equal(2+3, 1, "msg")
        1.should_not_equal 2+3
      end

      def test_assert_same
        assert_same(2, 1+1)
        (1+1).should_be 2
      end

      def test_assert_same_with_msg
        assert_same(2, 1+1, "msg")
        (1+1).should_be 2
      end

      def test_assert_not_same
        assert_not_same(2+3, 1)
        1.should_not_be 2+3
      end

      def test_assert_not_same_with_message
        assert_not_same(2+3, 1, "msg")
        1.should_not_be 2+3
      end

      def test_assert_instance_of
        assert_instance_of Fixnum, 2
        2.should_be_instance_of Fixnum
      end

      def test_assert_kind_of
        assert_kind_of Fixnum, 2
        2.should_be_kind_of Fixnum
      end

      def test_assert_match
        assert_match(/foo/, 'foo')
        'foo'.should_match(/foo/)
      end

      def test_assert_no_match
        assert_no_match(/foo/, 'bar')
        'bar'.should_not_match(/foo/)
      end

      def test_assert_respond_to
        assert_respond_to 2, :to_f
        2.should_respond_to :to_f
      end
      
      def test_assert_respond_to_with_message
        assert_respond_to 2, :to_f, "msg"
        2.should_respond_to :to_f
      end
      
      def test_assert_in_delta
        assert_in_delta 123.5, 123.45, 0.1
        123.45.should_be_close 123.5, 0.1
      end

      def test_assert_in_delta_with_message
        assert_in_delta 123.5, 123.45, 0.1, "123.45 should be close to 123.5"
        123.45.should_be_close 123.5, 0.1
      end
      
      def test_assert_raise
        assert_raise(ZeroDivisionError){ 1/0 }
        lambda {1/0}.should_raise(ZeroDivisionError)
      end
      
      def test_assert_raise_with_message
        assert_raise(ZeroDivisionError, "msg"){ 1/0 }
        lambda {1/0}.should_raise(ZeroDivisionError)
      end
      
      def test_assert_raises
        assert_raises(ZeroDivisionError){ 1/0 }
        lambda {1/0}.should_raise(ZeroDivisionError)
      end
      
      def test_assert_nothing_raised
        assert_nothing_raised{ 0/1 }
        lambda {0/1}.should_not_raise
      end

      def test_assert_throws
        assert_throws(:foo){ throw :foo }
        lambda {throw :foo}.should_throw(:foo)
      end

      def test_assert_nothing_thrown
        assert_nothing_thrown{ 0/1 }
        lambda {0/1}.should_not_throw
      end
      
      def test_assert_block
        assert_block{:foo != :bar}
        lambda{:foo != :bar}.should_be true
      end

      # Returns the body of one of my methods as a Sexp
      def self.body(sym)
        t = ParseTree.new.parse_tree_for_method(self, sym)
        t[2][1][2..-1]
      end

      # Verifies that the 1st statement in test method +m+ is properly translated
      # to the 2nd statement.
      def should_translate(m)
        body = self.class.body(m)
        assert_equal 2, body.length
        test_unit_sexp = body[0]
        rspec_sexp = body[1]
        translation = @t.process(test_unit_sexp)
        verify_sexp_equal(rspec_sexp, translation)
      end
      
      # Dynamically define extra test methods
      methods = self.instance_methods(false).reject do |m| 
        m == "test_translations" || !(m =~ /^test_assert/)
      end
      methods.each do |m|
        define_method "#{m}_translation" do
          should_translate(m)
        end
      end

    end
  end
end
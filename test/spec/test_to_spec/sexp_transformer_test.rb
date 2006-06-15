require File.dirname(__FILE__) + '/../../test_helper'
require 'test/unit'
require 'rubygems'
require 'parse_tree'
require 'spec/test_to_spec/sexp_transformer'
require 'spec/test_to_spec/ruby2ruby'

module Spec
  module TestToSpec
    class FirstTest < Test::Unit::TestCase
      def test_foo
      end
    end
    class FirstContext
      def wrapper
        context "First" do
          specify "foo" do
          end
        end
      end
    end

    class SecondTest < Test::Unit::TestCase
      def test_foo
        assert_same 3, 1+2
        assert_match /sla/, 'aslak'
      end
    end
    class SecondContext
      def wrapper
        context "Second" do
          specify "foo" do
            (1+2).should_be 3
            'aslak'.should_match(/sla/)
          end
        end
      end
    end

    class ThirdTest < Test::Unit::TestCase
      def test_bar
        one = 1
        two = 2
      end
      def test_foo
      end
    end
    class ThirdContext
      def wrapper
        context "Third" do
          specify "bar" do
            one = 1
            two = 2
          end
          specify "foo" do
          end
        end
      end
    end

    class FourthTest < Test::Unit::TestCase
      def setup
        one = 1
      end
      def test_foo
        two = 2
      end
    end
    class FourthContext
      def wrapper
        context "Fourth" do
          setup do
            one = 1
          end
          specify "foo" do
            two = 2
          end
        end
      end
    end

    class FifthTest
      def setup
        one = 1
      end
      def foo
        two = 2
      end
    end
    class FifthContext
      def wrapper
        context "Fifth" do
          setup do
            one = 1
            def foo
              two = 2
            end
          end
        end
      end
    end

    class SixthTest
      def setup
      end
      def foo
        two = 2
      end
    end
    class SixthContext
      def wrapper
        context "Sixth" do
          setup do
            def foo
              two = 2
            end
          end
        end
      end
    end

    class SeventhTest
      def foo
        two = 2
      end
    end
    class SeventhContext
      def wrapper
        context "Seventh" do
          setup do
            def foo
              two = 2
            end
          end
        end
      end
    end

    class EighthTest < Test::Unit::TestCase
      def foo
        two = 2
      end

      def teardown
        torn = true
      end
      
      def test_foo
        bar = foo
        assert_equal 2, bar
      end
    end
    class EighthContext
      def wrapper
        context "Eighth" do
          setup do
            def foo
              two = 2
            end
          end
          teardown do
            torn = true
          end
          specify "foo" do
            bar = foo
            bar.should_equal 2
          end
        end
      end
    end

    class SexpTransformerTest < Test::Unit::TestCase
      def test_first
        should_translate_class_to_context('First')
      end

      def test_second
        should_translate_class_to_context('Second')
      end

      def test_third
        should_translate_class_to_context('Third')
      end

      def test_fourth
        should_translate_class_to_context('Fourth')
      end

      def test_fifth
        should_translate_class_to_context('Fifth')
      end

      def test_sixth
        should_translate_class_to_context('Sixth')
      end

      def test_seventh
        should_translate_class_to_context('Seventh')
      end

      def test_eighth
        should_translate_class_to_context('Eighth')
      end

      def should_translate_class_to_context(name, debug=false)
        t = test_class_exp(eval("#{name}Test"))
        if(debug)
          puts "ORIGINAL"
          pp t
        end
        c = context_exp(eval("#{name}Context"))

        trans = @t.process(t)
        verify_sexp_equal c, trans
        
        # Verify that we can evaluate it after translated by R2R
        eval(@r2r.process(trans[0]))
      end

      def test_class_exp(klass)
        ParseTree.new.parse_tree(klass)[0]
      end

      def context_exp(klass)
#pp ParseTree.new.parse_tree_for_method(klass, :wrapper)
#exit
        ParseTree.new.parse_tree_for_method(klass, :wrapper)[2][1][2..-1]
      end

      def setup
        @t = SexpTransformer.new
        @r2r = RubyToRuby.new
      end
    end
  end
end
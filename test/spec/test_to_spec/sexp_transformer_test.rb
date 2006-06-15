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
    
    class NinthTest < Test::Unit::TestCase
      def test_2_should_be_pair
        foo = 1
        assert_pair(2)
      end
      
      def assert_pair(n)
        assert_equal 0, n%2
      end
    end
    class NinthContext
      def wrapper
        context "Ninth" do
          setup do
            def assert_pair(n)
              (n%2).should_equal 0
            end
          end
          specify "2 should be pair" do
            foo = 1
            assert_pair(2)
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

      def test_ninth
        should_translate_class_to_context('Ninth')
      end

      class Something
        def method_with_asserts
          assert_equal 2, 3
        end
      end
      class SomethingTranslated
        def method_with_asserts
          3.should_equal 2
        end
      end
      def test_translates_regular_method_bodies
        something = ParseTree.new.parse_tree_for_method(Something, :method_with_asserts)
        expected_something_translated = ParseTree.new.parse_tree_for_method(SomethingTranslated, :method_with_asserts)
        actual_something_translated = @t.process(something)
        verify_sexp_equal expected_something_translated, actual_something_translated
      end

      def should_translate_class_to_context(name, debug=false)
        test_class_name = "#{name}Test"
        context_class_name = "#{name}Context"
        t = test_class_exp(eval(test_class_name))
        if(debug)
          puts "ORIGINAL"
          pp t
        end
        c = wrapper_exp(eval(context_class_name))

        trans = @t.process(t)

        verify_sexp_equal c, trans

=begin
        if c != trans
          # Try to print out the Ruby2Ruby of the trans
          begin
            trans2ruby = @r2r.process(trans.dup[0])
            # Parse the translation again
            retranslated_class_name = "#{context_class_name}Retranslated"
            eval "class #{retranslated_class_name}\ndef wrapper\n#{trans2ruby}\nend\nend"
            retranslated_class = eval(retranslated_class_name)
            retranslated_tree = wrapper_exp(retranslated_class)
            retranslated_tree
            verify_sexp_equal c, retranslated_tree
          rescue SexpProcessorError => e
            # That didn't work, just print the tree
            verify_sexp_equal c, trans
          end
        end
=end        
        # Verify that we can evaluate it after translated by R2R
        eval(@r2r.process(trans[0]))
      end

      def test_class_exp(klass)
        ParseTree.new.parse_tree(klass)[0]
      end

      def wrapper_exp(klass)
        ParseTree.new.parse_tree_for_method(klass, :wrapper)[2][1][2..-1]
      end

      def setup
        @t = SexpTransformer.new
        @r2r = RubyToRuby.new
      end
    end
  end
end
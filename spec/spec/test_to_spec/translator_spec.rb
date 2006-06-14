#!/usr/bin/env ruby
require 'spec'
require 'rubygems'
require 'parse_tree'
require 'pp'

class Sample
  def self.body(sym)
    t = ParseTree.new.parse_tree_for_method(self, sym)
    t[2][1][2..-1]
  end

  def assert_equal
    assert_equal(3, 1+2)
  end
  def assert_equal_translated
    (1+2).should_equal(3)
  end

  def assert_instance_of
    assert_instance_of(Numeric, 1+2)
  end
  def assert_instance_of_translated
    (1+2).should_be_instance_of(Numeric)
  end
end

class Translator
  PLAIN_TRANSLATIONS = {
    :assert_equal => :should_equal,
    :assert_instance_of => :should_be_instance_of
  }
  
  def translate(exp)
    translate_plain(exp)
  end
  
  def translate_plain(exp)
    test_unit_fcall = exp[1]
    rspec_should = PLAIN_TRANSLATIONS[test_unit_fcall]
    args = exp[2]
    actual = args.delete_at(2)
    exp.clear
    exp.concat [:call, actual, rspec_should, args]
    nil
  end
end

context "Translator" do
  setup do
    @t = Translator.new
    
    def should_translate(m)
      exp = Sample.body(m)[0]
      expected = Sample.body("#{m}_translated".to_sym)[0]
      @t.translate(exp)
      if(exp != expected)
        puts "expected translation:"
        pp expected
        puts "actual translation:"
        pp exp
        violated("not equal")
      end
    end
  end
  
  specify "should translate assert_equal" do
    should_translate :assert_equal
  end

  specify "should translate assert_instance_of" do
    should_translate :assert_instance_of
  end
end
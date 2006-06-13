#!/usr/bin/env ruby
require 'spec'
require 'rubygems'
require 'parse_tree'

class Example
  def self.body(sym)
    t = ParseTree.new.parse_tree_for_method(self, sym)
    t[2][1][2]
  end

  def _assert_equal
    assert_equal("expected", "actual")
  end
  def _should_equal
    "actual".should_equal "expected"
  end

end

class Translator
  # TODO: deep-clone and transform original tree inline?
  # Look for method name and dispatch. Make extensible so it works with rails's assert_*
  def translate(exp)
    actual = exp[2][2]
    expected = exp[2][1]
    [:call, actual, :should_equal, [:array, expected]]
  end
end

context "Translator" do
  setup do
    @t = Translator.new
    
    def should_translate(from, to)
      exp = Example.body(from)
      expected = Example.body(to)
      trans = @t.translate(exp)
      trans.should_equal expected
    end
  end
  
  specify "should translate assert_equal" do
    should_translate :_assert_equal, :_should_equal
  end
end
# add ensure_that(..)
module Spec::Expectations::ObjectExpectations
  def ensure_that(obj, expr)
    obj.should expr
  end
end

def exception_from(&block)
  begin
    yield
  rescue StandardError => e
    e
  end
end

# simplify matchers

class SimpleMatcher
  def initialize(description, &match_block)
    @description = description
    @match_block = match_block
  end
  
  def matches?(actual)
    @actual = actual
    return @match_block.call(actual)
  end
  
  def failure_message()
    return %[Expected #@description but got #@actual]
  end
  
  def negative_failure_message()
    return %[Expected not to get #@description, but got #@actual]
  end
  
  def to_s
    failure_message
  end
end

# custom matchers

def contain(string)
  return SimpleMatcher.new(%[string containing "#{string}"]) do |actual|
    actual.include? string
  end
end

alias :contains :contain

def is(expected)
  return SimpleMatcher.new("equal to #{expected}") do |actual| actual == expected end
end

alias :are :is

def is_a(type)
  return SimpleMatcher.new("object of type #{type}") do |actual|
    actual.is_a? type
  end
end

alias :is_an :is_a

def matches(pattern)
  return SimpleMatcher.new("string matching #{pattern}") do |actual|
    actual =~ pattern
  end
end

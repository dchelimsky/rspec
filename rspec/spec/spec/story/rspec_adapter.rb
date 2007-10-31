# add ensure_that(..)
module Spec::Expectations::ObjectExpectations
  def ensure_that(obj, expr)
    obj.should expr
  end
end

def exception_from(&block)
  exception = nil
  begin
    yield
  rescue StandardError => e
    exception = e
  end
  exception
end

# simplify matchers


# custom matchers

def contain(string)
  return simple_matcher(%[string containing "#{string}"]) do |actual|
    actual.include? string
  end
end

alias :contains :contain

def is(expected)
  return simple_matcher("equal to #{expected}") do |actual| actual == expected end
end

alias :are :is

def is_a(type)
  return simple_matcher("object of type #{type}") do |actual|
    actual.is_a? type
  end
end

alias :is_an :is_a

def matches(pattern)
  return simple_matcher("string matching #{pattern}") do |actual|
    actual =~ pattern
  end
end
